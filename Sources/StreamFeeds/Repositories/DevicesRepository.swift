//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

final class DevicesRepository: Sendable {
    private let devicesClient: DevicesAPI
    
    init(devicesClient: DevicesAPI) {
        self.devicesClient = devicesClient
    }

    func queryDevices() async throws -> ListDevicesResponse {
        try await devicesClient.listDevices()
    }
    
    func createDevice(id: String, pushConfig: PushNotificationsConfig) async throws {
        guard !id.isEmpty else {
            throw ClientError("Device id must not be empty when trying to set device.")
        }
        guard let provider = CreateDeviceRequest.PushProvider(
            rawValue: pushConfig.pushProviderInfo.pushProvider.rawValue
        ) else {
            throw ClientError.Unexpected("Invalid push provider value")
        }
        let request = CreateDeviceRequest(
            id: id,
            pushProvider: provider,
            pushProviderName: pushConfig.pushProviderInfo.name,
            voipToken: nil
        )
        _ = try await devicesClient.createDevice(createDeviceRequest: request)
    }
    
    func deleteDevice(deviceId: String) async throws {
        _ = try await devicesClient.deleteDevice(id: deviceId)
    }
}
