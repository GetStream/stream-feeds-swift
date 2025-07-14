//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

struct UserCredentials: Identifiable {
    let user: User
    let token: UserToken
    var id: String {
        user.id
    }
}

extension UserCredentials {
    static let builtIn: [UserCredentials] = [
        .luke,
        .martin,
        .tommaso,
        .thierry,
        .marcelo,
        .kanat,
        .toomas
    ].sorted(by: { $0.user.name.localizedCaseInsensitiveCompare($1.user.name) == .orderedAscending })
    
    static let luke = UserCredentials(
        user: .init(id: "luke_skywalker", name: "Luke Skywalker", imageURL: URL(string: "https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg")),
        token: UserToken(rawValue: DemoAppConfig.current.tokenForUser("luke_skywalker"))
    )

    static let martin = UserCredentials(
        user: .init(id: "martin", name: "Martin", imageURL: URL(string: "https://getstream.io/static/2796a305dd07651fcceb4721a94f4505/802d2/martin-mitrevski.webp")),
        token: UserToken(rawValue: DemoAppConfig.current.tokenForUser("martin"))
    )
    
    static let tommaso = UserCredentials(
        user: .init(id: "tommaso", name: "Tommaso", imageURL: URL(string: "https://getstream.io/static/712bb5c0bd5ed8d3fa6e5842f6cfbeed/c59de/tommaso.webp")),
        token: UserToken(rawValue: DemoAppConfig.current.tokenForUser("tommaso"))
    )
    
    static let thierry = UserCredentials(
        user: .init(id: "thierry", name: "Thierry", imageURL: URL(string: "https://getstream.io/static/237f45f28690696ad8fff92726f45106/c59de/thierry.webp")),
        token: UserToken(rawValue: DemoAppConfig.current.tokenForUser("thierry"))
    )
    
    static let marcelo = UserCredentials(
        user: .init(id: "marcelo", name: "Marcelo", imageURL: URL(string: "https://getstream.io/static/aaf5fb17dcfd0a3dd885f62bd21b325a/802d2/marcelo-pires.webp")),
        token: UserToken(rawValue: DemoAppConfig.current.tokenForUser("marcelo"))
    )
    
    static let kanat = UserCredentials(
        user: .init(id: "kanat", name: "Kanat"),
        token: UserToken(rawValue: DemoAppConfig.current.tokenForUser("kanat"))
    )
    
    static let toomas = UserCredentials(
        user: .init(id: "toomas", name: "Toomas"),
        token: UserToken(rawValue: DemoAppConfig.current.tokenForUser("toomas"))
    )
    
    var fid: String {
        "user:\(id)"
    }
    
    static func credentials(for id: String) -> UserCredentials {
        if let credentials = builtIn.first(where: { $0.id == id }) {
            return credentials
        }
        return .tommaso
    }
}
