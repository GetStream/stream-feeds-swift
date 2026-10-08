//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
@testable import StreamCore
@testable import StreamFeedsLogsUI
import Testing

// The nested suites share `LogConfig` and `InMemoryLogRecorder.shared`, so they must not run in parallel.
@Suite(.serialized)
struct LogViewer_Tests {}

extension LogViewer_Tests {
    final class DestinationTests {
        private let destination: LogViewerDestination

        init() {
            InMemoryLogRecorder.shared.removeAll()
            InMemoryLogRecorder.shared.isRecording = true
            destination = LogViewerDestination(
                identifier: "",
                level: .debug,
                subsystems: .all,
                showDate: true,
                dateFormatter: DateFormatter(),
                formatters: [],
                showLevel: true,
                showIdentifier: false,
                showThreadName: true,
                showFileName: true,
                showLineNumber: true,
                showFunctionName: true
            )
        }

        deinit {
            InMemoryLogRecorder.shared.removeAll()
            InMemoryLogRecorder.shared.isRecording = true
        }

        @Test func processRecordsEntry() throws {
            let date = Date(timeIntervalSince1970: 1_700_000_000)

            destination.process(logDetails: logDetails(date: date))

            let entry = try #require(InMemoryLogRecorder.shared.entries.last)
            #expect(entry.date == date)
            #expect(entry.level == .warning)
            #expect(entry.subsystems == ["httpRequests"])
            #expect(entry.message == "200 GET /api/v2/feeds")
            #expect(entry.threadName == "main")
            #expect(entry.functionName == "request()")
            #expect(entry.fileName == "URLSessionTransport.swift")
            #expect(entry.lineNumber == 42)
            #expect(entry.metadata == [:])
        }

        @Test func processHTTPAttachmentRecordsHTTPMetadata() throws {
            let url = try #require(URL(string: "https://feeds.stream-io-api.com/api/v2/feeds"))
            let response = try #require(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
            let attachment = HTTPLogAttachment(
                request: URLRequest(url: url),
                response: response,
                responseBody: Data(#"{"id":1}"#.utf8)
            )

            destination.process(logDetails: logDetails(attachment: attachment))

            let metadata = try #require(InMemoryLogRecorder.shared.entries.last?.metadata)
            #expect(metadata[.httpMethod] == "GET")
            #expect(metadata[.httpURL] == url.absoluteString)
            #expect(metadata[.httpStatusCode] == "200")
            #expect(metadata[.httpResponseBody] == "{\n  \"id\" : 1\n}")
            #expect(metadata[.httpCURL] != nil)
        }

        @Test func processWebSocketAttachmentRecordsPayloadAndEventType() {
            let attachment = WebSocketLogAttachment(direction: .received, payload: Data(#"{"type":"feeds.activity.added"}"#.utf8))

            destination.process(logDetails: logDetails(attachment: attachment))

            #expect(InMemoryLogRecorder.shared.entries.last?.metadata == [
                .webSocketEventType: "feeds.activity.added",
                .webSocketReceivedPayload: "{\n  \"type\" : \"feeds.activity.added\"\n}"
            ])
        }

        @Test func processSentWebSocketAttachmentRecordsSentPayload() {
            let attachment = WebSocketLogAttachment(direction: .sent, payload: Data("ping".utf8))

            destination.process(logDetails: logDetails(attachment: attachment))

            #expect(InMemoryLogRecorder.shared.entries.last?.metadata == [.webSocketSentPayload: "ping"])
        }

        @Test func processCustomAttachmentRecordsItsDescription() {
            destination.process(logDetails: logDetails(attachment: CustomAttachment()))

            #expect(InMemoryLogRecorder.shared.entries.last?.metadata == ["Details": "custom"])
        }

        @Test func isEnabledWhenNotRecordingReturnsFalse() {
            #expect(destination.isEnabled(level: .debug, subsystems: .other))

            InMemoryLogRecorder.shared.isRecording = false

            #expect(!destination.isEnabled(level: .debug, subsystems: .other))
        }

        @Test func logLevelFromLogEntryLevel() {
            #expect(LogLevel(LogEntry.Level.trace) == .debug)
            #expect(LogLevel(LogEntry.Level.debug) == .debug)
            #expect(LogLevel(LogEntry.Level.info) == .info)
            #expect(LogLevel(LogEntry.Level.notice) == .info)
            #expect(LogLevel(LogEntry.Level.warning) == .warning)
            #expect(LogLevel(LogEntry.Level.error) == .error)
            #expect(LogLevel(LogEntry.Level.critical) == .error)
        }

        @Test func logEntryLevelFromLogLevel() {
            #expect(LogEntry.Level(LogLevel.debug) == .debug)
            #expect(LogEntry.Level(LogLevel.info) == .info)
            #expect(LogEntry.Level(LogLevel.warning) == .warning)
            #expect(LogEntry.Level(LogLevel.error) == .error)
        }

        private func logDetails(date: Date = Date(), attachment: (any LogAttachment)? = nil) -> LogDetails {
            LogDetails(
                loggerIdentifier: "",
                subsystem: .httpRequests,
                level: .warning,
                date: date,
                message: "200 GET /api/v2/feeds",
                threadName: "[main] ",
                functionName: "request()",
                fileName: "URLSessionTransport.swift",
                lineNumber: 42,
                error: nil,
                attachment: attachment
            )
        }
    }

    @MainActor
    final class InstallTests {
        private nonisolated static let userDefaultsSuiteName = "LogViewer_Tests"
        private let settings: LogSettings

        init() throws {
            UserDefaults().removePersistentDomain(forName: Self.userDefaultsSuiteName)
            settings = try LogSettings(userDefaults: #require(UserDefaults(suiteName: Self.userDefaultsSuiteName)))
            LogConfig.destinationTypes = [ConsoleLogDestination.self]
            LogConfig.level = .warning
            LogConfig.subsystems = [.httpRequests, .webSocket]
        }

        deinit {
            LogConfig.reset()
            UserDefaults().removePersistentDomain(forName: Self.userDefaultsSuiteName)
        }

        @Test func installWithSharedSettingsListsStreamFeedsSubsystems() {
            LogSettings.shared.reset()
            defer { LogSettings.shared.reset() }

            LogViewer.install()

            #expect(LogSettings.shared.availableSubsystems == ["other", "httpRequests", "webSocket"])
            #expect(LogConfig.destinations.contains { $0 is LogViewerDestination })
        }

        @Test func installSetsDefaultsFromLogConfig() {
            LogViewer.install(subsystems: [.other, .httpRequests, .webSocket], settings: settings)

            #expect(settings.availableLevels == [.debug, .info, .warning, .error])
            #expect(settings.availableSubsystems == ["other", "httpRequests", "webSocket"])
            #expect(settings.destinations == [
                LogDestinationSettings(id: "console", name: "Console", level: .warning, disabledSubsystems: ["other"]),
                LogDestinationSettings(id: "logViewer", name: "Log Viewer", level: .debug)
            ])
        }

        @Test func installSetsConsoleAndLogViewerDestinations() throws {
            LogConfig.formatters = [PrefixLogFormatter(prefixes: [.warning: "⚠️"])]

            LogViewer.install(subsystems: [.other, .httpRequests, .webSocket], settings: settings)

            let destinations = LogConfig.destinations
            #expect(destinations.count == 2)
            let console = try #require(destinations.first as? ConsoleLogDestination)
            #expect(console.level == .warning)
            #expect(console.subsystems == [.httpRequests, .webSocket])
            #expect(console.formatters.count == 1)
            let logViewer = try #require(destinations.last as? LogViewerDestination)
            #expect(logViewer.level == .debug)
            #expect(logViewer.subsystems == .all)
        }

        @Test func settingsChangeUpdatesDestinations() throws {
            LogViewer.install(subsystems: [.other, .httpRequests, .webSocket], settings: settings)

            settings.destinations[0].level = .info
            settings.destinations[0].disabledSubsystems = []
            settings.destinations[1].isEnabled = false

            let destinations = LogConfig.destinations
            #expect(destinations.count == 1)
            let console = try #require(destinations.first as? ConsoleLogDestination)
            #expect(console.level == .info)
            #expect(console.subsystems == .all)
        }

        @Test func settingsChangeWithDisabledSubsystemKeepsOnlyEnabledListedSubsystems() throws {
            LogViewer.install(subsystems: [.other, .httpRequests, .webSocket], settings: settings)

            settings.destinations[1].disabledSubsystems = ["webSocket"]

            let logViewer = try #require(LogConfig.destinations.last as? LogViewerDestination)
            #expect(logViewer.subsystems == [.other, .httpRequests])
        }
    }
}

private struct CustomAttachment: LogAttachment {
    var logDescription: String { "custom" }
}
