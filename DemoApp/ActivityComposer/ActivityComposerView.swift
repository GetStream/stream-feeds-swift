//
//  ActivityComposerView.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 30.5.25.
//

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
                            print("======= \(error)")
                        }
                    }
                } label: {
                    Text("Post")
                        .bold()
                }
            }
            .padding()
            if let assets = viewModel.imageAssets {
                PhotoAttachmentPickerView(
                    assets: PHFetchResultCollection(fetchResult: assets),
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
