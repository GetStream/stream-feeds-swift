//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct ActivityComposerView: View {
    @StateObject var viewModel: ActivityComposerViewModel
    @State var textHeight: CGFloat = TextSizeConstants.minimumHeight
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
                if viewModel.showCommandsOverlay && !viewModel.suggestions.isEmpty {
                    CommandsContainerView(suggestions: viewModel.suggestions) { commandInfo in
                        viewModel.handleCommand(
                            for: $viewModel.text,
                            selectedRangeLocation: $viewModel.selectedRangeLocation,
                            command: $viewModel.composerCommand,
                            extraData: commandInfo
                        )
                    }
                    .id(viewModel.text)
                    .background(Color(UIColor.systemBackground))
                }
                
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
                
                HStack {
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
                    
                    Spacer()
                    
                    if viewModel.storiesEnabled {
                        Toggle(isOn: $viewModel.postAsStory) {
                            Text("Post as story")
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        .frame(width: 150)
                    }
                }
                .padding(.horizontal)
                
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
        }
        .onAppear {
            viewModel.askForPhotosPermission()
        }
    }
}
