//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct ActivityComposerView: View {
    @StateObject var viewModel: ActivityComposerViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(feed: Feed, feedsClient: FeedsClient) {
        _viewModel = StateObject(wrappedValue: ActivityComposerViewModel(feed: feed, feedsClient: feedsClient))
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Add post", text: $viewModel.text)
                    .textFieldStyle(.roundedBorder)
                
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
            }
        }
        .onAppear {
            viewModel.askForPhotosPermission()
        }
    }
}
