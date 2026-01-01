//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCoreUI

class Utils {
    nonisolated(unsafe) static let shared = Utils()
    
    let imageLoader: ImageLoading = DefaultImageLoader()
    let imageCDN: ImageCDN = StreamImageCDN()
    let videoPreviewLoader: VideoLoading = StreamVideoLoader()
    
    private init() {}
}
