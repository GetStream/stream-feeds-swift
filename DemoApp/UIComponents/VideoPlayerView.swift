//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import AVKit
import StreamCore
import StreamFeeds
import SwiftUI

struct VideoPlayerView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var attachment: Attachment?
    
    @State private var avPlayer: AVPlayer?
    @State private var error: Error?

    init(
        attachment: Binding<Attachment?>
    ) {
        _attachment = attachment
    }

    public var body: some View {
        VStack {
            if let avPlayer {
                VideoPlayer(player: avPlayer)
            }
        }
        .onAppear {
            guard let assetUrl = attachment?.assetUrl, let url = URL(string: assetUrl) else {
                return
            }
            avPlayer = AVPlayer(url: url)
            try? AVAudioSession.sharedInstance().setCategory(.playback, options: [])
            avPlayer?.play()
        }
        .onDisappear {
            attachment = nil
            avPlayer?.replaceCurrentItem(with: nil)
        }
    }
}
