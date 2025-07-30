//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamFeeds

/// Configuration for the commands in the composer.
public protocol CommandsConfig {
    /// The symbol that invokes mentions command.
    var mentionsSymbol: String { get }

    /// The symbol that invokes instant commands.
    var instantCommandsSymbol: String { get }

    /// Creates the main commands handler.
    /// - Parameter channelController: the controller of the channel.
    /// - Returns: `CommandsHandler`.
    func makeCommandsHandler(
        with feed: Feed
    ) -> CommandsHandler
}

/// Default commands configuration.
public class DefaultCommandsConfig: CommandsConfig {
    public init() {
        // Public init.
    }

    public let mentionsSymbol: String = "@"
    public let instantCommandsSymbol: String = "/"

    public func makeCommandsHandler(
        with feed: Feed
    ) -> CommandsHandler {
        let mentionsCommandHandler = MentionsCommandHandler(
            feed: feed,
            commandSymbol: mentionsSymbol,
            mentionAllAppUsers: false
        )

        var instantCommands = [CommandHandler]()

        let giphyCommand = GiphyCommandHandler(commandSymbol: "/giphy")
        instantCommands.append(giphyCommand)

        let instantCommandsHandler = InstantCommandsHandler(
            commands: instantCommands
        )
        return CommandsHandler(commands: [mentionsCommandHandler, instantCommandsHandler])
    }
}
