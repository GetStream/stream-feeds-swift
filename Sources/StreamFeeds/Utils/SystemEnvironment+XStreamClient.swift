//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import IOKit
#endif

extension SystemEnvironment {
    static let xStreamClientHeader: String = {
        "stream-feeds-\(sdkIdentifier)-v\(version)|app=\(appName)|app_version=\(appVersion)|os=\(os) \(osVersion)|device_model=\(model)"
    }()

    private static var sdkIdentifier: String {
        "swift"
    }

    private static var info: [String: Any] {
        Bundle.main.infoDictionary ?? [:]
    }

    private static var appName: String {
        ((info["CFBundleDisplayName"] ?? info[kCFBundleIdentifierKey as String]) as? String) ?? "App name unavailable"
    }

    private static var appVersion: String {
        (info["CFBundleShortVersionString"] as? String) ?? "0"
    }

    private static var model: String {
        #if os(iOS)
        return deviceModelName
        #elseif os(macOS)
        return macModelIdentifier
        #endif
    }

    #if os(macOS)
    private static var macModelIdentifier: String = {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        var model = "MacOS device"

        if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0)
            .takeRetainedValue() as? Data,
            let deviceModelString = String(data: modelData, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters) {
            model = deviceModelString
        }

        IOObjectRelease(service)
        return model
    }()
    #endif

    private static var osVersion: String {
        ProcessInfo.processInfo.operatingSystemVersionString
    }

    private static var os: String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "MacOS"
        #endif
    }
}

extension SystemEnvironment {
  /// A Stream Chat version.
  public static let version: String = "0.1.0"
}
