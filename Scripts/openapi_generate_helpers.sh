# shellcheck shell=bash

pruned_endpoints=()
pruned_model_count=0

# Drops properties from a generated model: declaration with docs, init parameter, coder lines,
# equality and hashing.
remove_property() {
  local file="$OUTPUT_DIR_FEEDS/models/$1.swift"
  local p
  for p in "${@:2}"; do
    awk -v p="$p" '
      function flush() { for (i = 1; i <= n; i++) print b[i]; n = 0 }
      { s = $0; sub(/^[[:space:]]+/, "", s) }
      s ~ /^(\/\/\/|@available)/         { b[++n] = $0; next }
      s ~ "^public let " p ": "          { n = 0; next }
      s ~ "^private let _" p ": "        { n = 0; next }
      s ~ "^public var " p ": .* \\{ _" p " \\}$" { n = 0; next }
      s ~ "^self\\._?" p " = " p "$"     { next }
      s ~ "^self\\._?" p " = try container\\.decode(IfPresent)?\\(.*, forKey: \\." p "\\)$" { next }
      s ~ "^lhs\\._?" p " == rhs\\._?" p "( &&)?$" { next }
      s ~ "^hasher\\.combine\\(_?" p "\\)$"    { next }
      s ~ "^try container\\.encode(IfPresent)?\\(_?" p ", forKey: \\." p "\\)$" { next }
      s ~ /^public init\(/ { sub("\\(" p ": [^,)]*, ", "("); sub(", " p ": [^,)]*", ""); sub("\\(" p ": [^,)]*\\)", "()") }
      { flush(); print }
    ' "$file" > "$file.tmp"
    if cmp -s "$file" "$file.tmp"; then
      rm "$file.tmp"
      echo "Removed property missing: $1.$p" >&2
      exit 1
    fi
    mv "$file.tmp" "$file"
    # Drop a trailing `&&` left dangling when the removed field was last in an == chain.
    perl -0777 -pi -e 's/ &&(\n\s*\})/$1/g' "$file"
    # A model left without properties has no wire keys, so synthesis can replace coders whose
    # container would go unused.
    perl -0777 -pi -e 's/\n\h*public (?:init\(from decoder: Decoder\) throws|func encode\(to encoder: Encoder\) throws) \{\n\h*(?:let|var) container = [^\n]+\n\h*\}\n//g' "$file"
  done
}

# Drops model properties listed in removedProperties.
remove_properties() {
  local model
  for model in $(jq -r '.removedProperties | keys[]' "$ALLOWED_FILE"); do
    remove_property "$model" $(jq -r --arg m "$model" '.removedProperties[$m][]' "$ALLOWED_FILE")
  done
}

# Drops DefaultAPI endpoints which are not in allowedEndpoints.
remove_unused_endpoints() {
  local file="$OUTPUT_DIR_FEEDS/APIs/DefaultAPI.swift"
  local allowed generated missing
  allowed="$(jq -r '.allowedEndpoints[]' "$ALLOWED_FILE" | sort)"
  generated="$(sed -n '/^protocol DefaultAPIEndpoints {/,$p' "$file" \
    | sed -nE 's/^    func ([A-Za-z0-9]+)\(.*/\1/p' | sort)"
  missing="$(comm -23 <(echo "$allowed") <(echo "$generated"))"
  if [ -n "$missing" ]; then
    echo "Allowed endpoints missing from DefaultAPI: $missing" >&2
    exit 1
  fi
  remove_endpoint $(comm -13 <(echo "$allowed") <(echo "$generated"))
}

# Keep only the coding direction each model needs.
# Required because OpenAPI generator emits all models with Codable conformance
# even when it is used for decoding or encoding only. This helps to save
# SDK size when Codable is reduced to Encodable or Decodable.
# Requires bigger change in the generator for applying it there.
apply_directional_coding_conformances() {
  local encodable_csv decodable_csv codable_csv
  encodable_csv="$(jq -r '.encodableOnlyModels | join(",")' "$ALLOWED_FILE")"
  decodable_csv="$(jq -r '.decodableOnlyModels | join(",")' "$ALLOWED_FILE")"
  codable_csv="$(jq -r '.codableModels | join(",")' "$ALLOWED_FILE")"

  sed -i '' 's/send<Response: Codable>/send<Response: Decodable>/' "$OUTPUT_DIR_FEEDS/APIs/DefaultAPI.swift"

  python3 - \
    "$OUTPUT_DIR_FEEDS/models" \
    "$encodable_csv" \
    "$decodable_csv" \
    "$codable_csv" <<'PY'
import pathlib
import re
import sys

models_dir = pathlib.Path(sys.argv[1])
groups = {
    "Encodable": set(filter(None, sys.argv[2].split(","))),
    "Decodable": set(filter(None, sys.argv[3].split(","))),
    "Codable": set(filter(None, sys.argv[4].split(","))),
}

all_classified = set()
for direction, names in groups.items():
    overlap = all_classified.intersection(names)
    if overlap:
        raise SystemExit(f"Models classified more than once: {sorted(overlap)}")
    all_classified.update(names)

generated = {path.stem for path in models_dir.glob("*.swift")}
unclassified = generated - all_classified
missing = all_classified - generated
if unclassified:
    raise SystemExit(f"Unclassified generated models: {sorted(unclassified)}")
if missing:
    raise SystemExit(f"Classified models missing from generated output: {sorted(missing)}")

# Every model gets an explicit init(from:) and encode(to:) from the generator; the one
# for the dropped coding direction no longer compiles. The other one must stay: without
# CodingKeys, synthesis would take the wire keys from the camelCase property names.
# Keyed by the direction that doesn't need the coder.
unused_coder = {
    "Decodable": r"func encode\(to encoder: Encoder\) throws",
    "Encodable": r"init\(from decoder: Decoder\) throws",
}

declaration = re.compile(
    r"^(\s*(?:public )?(?:final )?(?:class|struct|enum)\s+([A-Za-z0-9_]+)[^:\n]*:\s*)(.*)$"
)

for direction, names in groups.items():
    for name in sorted(names):
        path = models_dir / f"{name}.swift"
        lines = path.read_text().splitlines(keepends=True)
        output = []
        top_level_conformances = None

        for line in lines:
            ending = "\n" if line.endswith("\n") else ""
            content = line[:-1] if ending else line
            match = declaration.match(content)
            if match:
                prefix, declared_name, conformances = match.groups()
                if declared_name == name:
                    if direction != "Codable":
                        conformances = re.sub(r"\bCodable\b", direction, conformances)
                        if direction == "Decodable":
                            conformances = re.sub(r",\s*JSONEncodable\b", "", conformances)
                    content = f"{prefix}{conformances}"
                    top_level_conformances = conformances
            output.append(content + ending)

        if top_level_conformances is None:
            raise SystemExit(f"Could not find the top-level declaration for {name}")
        if not re.search(rf"\b{direction}\b", top_level_conformances):
            raise SystemExit(f"{name} does not conform to {direction}")
        if direction == "Decodable" and re.search(
            r"\bEncodable\b|\bJSONEncodable\b", top_level_conformances
        ):
            raise SystemExit(f"{name} retains an encoding conformance")

        text = "".join(output)
        if direction in unused_coder:
            text = re.sub(
                rf"\n?^    (?:public )?{unused_coder[direction]} \{{\n.*?^    \}}\n",
                "",
                text,
                count=1,
                flags=re.M | re.S,
            )
        path.write_text(text)
PY
}

# Drops StringCodingKey members which neither generated nor handwritten code references.
prune_unused_string_coding_keys() {
  python3 - "$OUTPUT_DIR_FEEDS/StringCodingKey.swift" "$OUTPUT_DIR_FEEDS" \
    "$REPO_ROOT/Sources" "$REPO_ROOT/Tests" <<'PY'
import pathlib
import re
import sys

keys_file, generated_dir = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
generated_reference = re.compile(r"(?:forKey: \.|StringCodingKey\.)`?(\w+)`?")
reference = re.compile(r"StringCodingKey\.`?(\w+)`?")
used = set()
for root in sys.argv[3:]:
    for path in pathlib.Path(root).rglob("*.swift"):
        if path == keys_file:
            continue
        pattern = generated_reference if path.is_relative_to(generated_dir) else reference
        used.update(pattern.findall(path.read_text()))

declaration = re.compile(r"^    static let `?(\w+)`?: StringCodingKey = ")
kept = [
    line
    for line in keys_file.read_text().splitlines(keepends=True)
    if not (match := declaration.match(line)) or match.group(1) in used
]
keys_file.write_text("".join(kept))
PY
}

# Drops endpoints from DefaultAPI and its protocol.
remove_endpoint() {
  local file="$OUTPUT_DIR_FEEDS/APIs/DefaultAPI.swift"
  local e
  for e in "$@"; do
    grep -q "^    open func $e(" "$file" || continue
    pruned_endpoints+=("$e")
    awk -v e="$e" '
      $0 ~ "^    open func " e "\\(" { skip = 1; next }
      skip && $0 == "    }"          { skip = 0; next }
      skip                            { next }
      $0 ~ "^    func " e "\\("      { next }
      { print }
    ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
  done
}

# Deletes models which are not reachable from DefaultAPI or the given root models.
prune_unreachable_models() {
  local models_dir="$OUTPUT_DIR_FEEDS/models"
  local all reachable previous="" model pruned_listed
  all="$(ls "$models_dir" | sed 's/\.swift$//' | sort)"
  reachable="$(printf '%s\n' "$@" | sort -u)"
  until [ "$reachable" = "$previous" ]; do
    previous="$reachable"
    reachable="$(
      sed "s|.*|$models_dir/&.swift|" <<< "$previous" \
        | xargs cat "$OUTPUT_DIR_FEEDS/APIs/DefaultAPI.swift" \
        | grep -vE '^[[:space:]]*//' \
        | grep -oE '[A-Za-z_][A-Za-z0-9_]*' \
        | cat - <(echo "$previous") | sort -u | comm -12 - <(echo "$all")
    )"
  done
  while IFS= read -r model; do
    [ -n "$model" ] || continue
    rm "$models_dir/$model.swift"
    pruned_model_count=$((pruned_model_count + 1))
  done <<< "$(comm -23 <(echo "$all") <(echo "$reachable"))"
  pruned_listed="$(jq -r '.removedProperties | keys[]' "$ALLOWED_FILE" | sort \
    | comm -23 - <(echo "$reachable"))"
  if [ -n "$pruned_listed" ]; then
    echo "Pruned models listed in removedProperties: $pruned_listed" >&2
    exit 1
  fi
}
