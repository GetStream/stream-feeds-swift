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
    ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    # Drop a trailing `&&` left dangling when the removed field was last in an == chain.
    perl -0777 -pi -e 's/ &&(\n\s*\})/$1/g' "$file"
    # A model left without properties has no wire keys, so synthesis can replace coders whose
    # container would go unused.
    perl -0777 -pi -e 's/\n\h*public (?:init\(from decoder: Decoder\) throws|func encode\(to encoder: Encoder\) throws) \{\n\h*(?:let|var) container = [^\n]+\n\h*\}\n//g' "$file"
  done
}

# Drops a RawRepresentable type generated for an inline enum, with its docs.
remove_type() {
  local file="$OUTPUT_DIR_FEEDS/models/$1.swift"
  awk -v e="$2" '
    function flush() { for (i = 1; i <= n; i++) print b[i]; n = 0 }
    !skip && /^\/\/\//                 { b[++n] = $0; next }
    $0 ~ "^public final class " e ":" { n = 0; skip = 1; next }
    skip && /^}$/                     { skip = 0; next }
    skip                              { next }
    { flush(); print }
  ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
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
  local all reachable previous model
  all="$(ls "$models_dir" | sed 's/\.swift$//' | sort)"
  reachable="$(printf '%s\n' "$@" | sort -u)"
  until [ "$reachable" = "$previous" ]; do
    previous="$reachable"
    reachable="$(
      sed "s|.*|$models_dir/&.swift|" <<< "$previous" \
        | xargs grep -ohE '[A-Za-z_][A-Za-z0-9_]*' "$OUTPUT_DIR_FEEDS/APIs/DefaultAPI.swift" \
        | cat - <(echo "$previous") | sort -u | comm -12 - <(echo "$all")
    )"
  done
  while IFS= read -r model; do
    [ -n "$model" ] || continue
    rm "$models_dir/$model.swift"
    pruned_model_count=$((pruned_model_count + 1))
  done <<< "$(comm -23 <(echo "$all") <(echo "$reachable"))"
}
