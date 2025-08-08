//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCoreUI

class Utils {
    nonisolated(unsafe) static let shared = Utils()
    
    let imageLoader: ImageLoading = DefaultImageLoader()
    let imageCDN: ImageCDN = StreamImageCDN()
    let videoPreviewLoader: VideoPreviewLoader = DefaultVideoPreviewLoader()
    
    private init() {}
}
