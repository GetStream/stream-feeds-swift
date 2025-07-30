//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct ActivityComposerView: View {
    @StateObject var viewModel: ActivityComposerViewModel
    @State var textHeight: CGFloat = TextSizeConstants.minimumHeight
    @State var mentionsPopupHeight: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    
    var textFieldHeight: CGFloat {
        let minHeight: CGFloat = TextSizeConstants.minimumHeight
        let maxHeight: CGFloat = TextSizeConstants.maximumHeight

        if textHeight < minHeight {
            return minHeight
        }

        if textHeight > maxHeight {
            return maxHeight
        }

        return textHeight
    }
    
    init(feed: Feed, feedsClient: FeedsClient) {
        _viewModel = StateObject(wrappedValue: ActivityComposerViewModel(feed: feed, feedsClient: feedsClient))
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    ComposerTextInputView(
                        text: $viewModel.text,
                        height: $textHeight,
                        selectedRangeLocation: $viewModel.selectedRangeLocation,
                        placeholder: "Add post",
                        editable: true,
                        currentHeight: textFieldHeight
                    )
                    .frame(height: textFieldHeight)
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.publishPost()
                                dismiss()
                            } catch {
                                log.error("Error publishing a post \(error)")
                                viewModel.publishingPost = false
                            }
                        }
                    } label: {
                        if viewModel.publishingPost {
                            ProgressView()
                        } else {
                            Text("Post")
                                .bold()
                        }
                    }
                    .disabled(
                        (viewModel.text.trimmed.isEmpty && viewModel.addedAssets.isEmpty)
                            || viewModel.publishingPost
                    )
                }
                .padding()
                
                Button {
                    viewModel.createPollShown = true
                } label: {
                    Text("Create Poll")
                }
                .sheet(isPresented: $viewModel.createPollShown) {
                    CreatePollView(feed: viewModel.feed) {
                        dismiss()
                    }
                }
                
                if let assets = viewModel.imageAssets {
                    PhotoAttachmentPickerView(
                        assets: PHFetchResultCollection(fetchResult: assets),
                        assetLoader: PhotoAssetLoader(client: viewModel.client),
                        onImageTap: viewModel.imageTapped(_:),
                        imageSelected: viewModel.isImageSelected(with:)
                    )
                } else {
                    Color.clear
                }
            }
            
            // Commands overlay positioned above the view
            if viewModel.showCommandsOverlay {
                VStack {
                    CommandsContainerView(suggestions: viewModel.suggestions) { commandInfo in
                        viewModel.handleCommand(
                            for: $viewModel.text,
                            selectedRangeLocation: $viewModel.selectedRangeLocation,
                            command: $viewModel.composerCommand,
                            extraData: commandInfo
                        )
                    }
                    .background(Color(UIColor.systemBackground))
                    .onPreferenceChange(HeightPreferenceKey.self) { value in
                        Task { @MainActor in
                            if let value, value != mentionsPopupHeight {
                                mentionsPopupHeight = value
                            }
                        }
                    }
                    
                    Spacer()
                }
                .offset(y: -mentionsPopupHeight - 200) // Position above the view
            }
        }
        .onAppear {
            viewModel.askForPhotosPermission()
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: CGFloat?

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}
