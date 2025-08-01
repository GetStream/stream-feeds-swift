//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Photos
import StreamCore
import StreamFeeds
import SwiftUI

@MainActor class ActivityComposerViewModel: ObservableObject {
    @Published public private(set) var imageAssets: PHFetchResult<PHAsset>?
    @Published public private(set) var addedAssets = [AddedAsset]()
    @Published public var text = "" {
        didSet {
            if text != "" {
                checkTypingSuggestions()
            } else {
                withAnimation {
                    if composerCommand?.displayInfo?.isInstant == false {
                        composerCommand = nil
                    }
                    selectedRangeLocation = 0
                    suggestions = [String: Any]()
                    mentionedUsers = Set<UserData>()
                }
            }
        }
    }

    @Published var createPollShown = false
    @Published var publishingPost = false
    @Published public var suggestions = [String: Any]()
    @Published public var selectedRangeLocation: Int = 0
    
    @Published public var composerCommand: ComposerCommand? {
        didSet {
            if oldValue?.id != composerCommand?.id &&
                composerCommand?.displayInfo?.isInstant == true {
                clearCommandText()
            }
        }
    }
    
    public var mentionedUsers: Set<UserData> = []
    
    let feed: Feed
    let client: FeedsClient
    let commandsHandler: CommandsHandler
        
    init(feed: Feed, feedsClient: FeedsClient) {
        client = feedsClient
        self.feed = feed
        let commandsConfig = DefaultCommandsConfig()
        commandsHandler = commandsConfig.makeCommandsHandler(with: feed)
    }
    
    func handleCommand(
        for text: Binding<String>,
        selectedRangeLocation: Binding<Int>,
        command: Binding<ComposerCommand?>,
        extraData: [String: Any]
    ) {
        let commandId = command.wrappedValue?.id
        commandsHandler.handleCommand(
            for: text,
            selectedRangeLocation: selectedRangeLocation,
            command: command,
            extraData: extraData
        )
        checkForMentionedUsers(
            commandId: commandId,
            extraData: extraData
        )
        suggestions = [:]
    }
    
    func askForPhotosPermission() {
        PHPhotoLibrary.requestAuthorization { @Sendable [weak self] (status) in
            guard let self else { return }
            switch status {
            case .authorized, .limited:
                log.debug("Access to photos granted.")
                Task { @MainActor in
                    self.fetchAssets()
                }
            case .denied, .restricted, .notDetermined:
                Task { @MainActor in
                    self.imageAssets = PHFetchResult<PHAsset>()
                }
                log.debug("Access to photos is denied or not determined, showing the no permissions screen.")
            @unknown default:
                log.debug("Unknown authorization status.")
            }
        }
    }
    
    func isImageSelected(with id: String) -> Bool {
        for image in addedAssets {
            if image.id == id {
                return true
            }
        }
        
        return false
    }
    
    func imageTapped(_ addedAsset: AddedAsset) {
        var images = [AddedAsset]()
        var imageRemoved = false
        for image in addedAssets {
            if image.id != addedAsset.id {
                images.append(image)
            } else {
                imageRemoved = true
            }
        }
        
        if !imageRemoved {
            images.append(addedAsset)
        }
        
        addedAssets = images
    }
    
    func publishPost() async throws {
        if text.isEmpty && addedAssets.isEmpty || publishingPost {
            return
        }
        
        publishingPost = true
        let attachments = try addedAssets.map { try $0.toAttachmentPayload() }
        _ = try await feed.addActivity(
            request: .init(
                attachmentUploads: attachments,
                mentionedUserIds: mentionedUsers.map(\.id),
                text: text,
                type: "activity"
            )
        )
        text = ""
        addedAssets = []
        publishingPost = false
    }
    
    public var showCommandsOverlay: Bool {
        // Mentions are really not commands, but at the moment this flag controls
        // if the mentions are displayed or not, so if the command is related to mentions
        // then we need to ignore if commands are available or not.
        let isMentionsSuggestions = composerCommand?.id == "mentions"
        if isMentionsSuggestions {
            return true
        }
        let commandAvailable = composerCommand != nil
        return commandAvailable
    }
    
    private func fetchAssets() {
        let fetchOptions = PHFetchOptions()
        let supportedTypes = GallerySupportedTypes.imagesAndVideo
        var predicate: NSPredicate?
        if supportedTypes == .images {
            predicate = NSPredicate(format: "mediaType = \(PHAssetMediaType.image.rawValue)")
        } else if supportedTypes == .videos {
            predicate = NSPredicate(format: "mediaType = \(PHAssetMediaType.video.rawValue)")
        }
        if let predicate {
            fetchOptions.predicate = predicate
        }
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            withAnimation {
                self?.imageAssets = assets
            }
        }
    }
    
    private func clearCommandText() {
        guard composerCommand != nil else { return }
        let currentText = text
        if let value = getValueOfCommand(currentText) {
            text = value
            return
        }
        text = ""
    }
    
    private func getValueOfCommand(_ currentText: String) -> String? {
        let pattern = "/\\S+\\s+(.*)"
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(currentText.startIndex..<currentText.endIndex, in: currentText)

            if let match = regex.firstMatch(in: currentText, range: range) {
                let valueRange = match.range(at: 1)

                if let range = Range(valueRange, in: currentText) {
                    return String(currentText[range])
                }
            }
        }
        return nil
    }
    
    private func checkTypingSuggestions() {
        if composerCommand?.displayInfo?.isInstant == true {
            let typingSuggestion = TypingSuggestion(
                text: text,
                locationRange: NSRange(
                    location: 0,
                    length: selectedRangeLocation
                )
            )
            composerCommand?.typingSuggestion = typingSuggestion
            showTypingSuggestions()
            return
        }
        composerCommand = commandsHandler.canHandleCommand(
            in: text,
            caretLocation: selectedRangeLocation
        )
        
        showTypingSuggestions()
    }
    
    private func showTypingSuggestions() {
        if let composerCommand {
            Task { @MainActor in
                let suggestionInfo = try await commandsHandler.showSuggestions(for: composerCommand)
                self.suggestions[suggestionInfo.key] = suggestionInfo.value
            }
        }
    }
    
    private func checkForMentionedUsers(
        commandId: String?,
        extraData: [String: Any]
    ) {
        guard commandId == "mentions",
              let user = extraData["user"] as? UserData else {
            return
        }
        mentionedUsers.insert(user)
    }
    
    private func clearRemovedMentions() {
        for user in mentionedUsers {
            if !text.contains("@\(user.mentionText)") {
                mentionedUsers.remove(user)
            }
        }
    }
}

public enum GallerySupportedTypes {
    case imagesAndVideo
    case images
    case videos
}

extension AddedAsset {
    func toAttachmentPayload() throws -> AnyAttachmentPayload {
        try AnyAttachmentPayload(
            localFileURL: url,
            attachmentType: type == .video ? .video : .image,
            extraData: extraData
        )
    }
}
