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
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibHVrZV9za3l3YWxrZXIifQ.hZ59SWtp_zLKVV9ShkqkTsCGi_jdPHly7XNCf5T_Ev0")
    )

    static let martin = UserCredentials(
        user: .init(id: "martin", name: "Martin", imageURL: URL(string: "https://getstream.io/static/2796a305dd07651fcceb4721a94f4505/802d2/martin-mitrevski.webp")),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFydGluIn0.-8mL49OqMdlvzXR_1IgYboVXXuXFc04r0EvYgko-X8I")
    )
    
    static let tommaso = UserCredentials(
        user: .init(id: "tommaso", name: "Tommaso", imageURL: URL(string: "https://getstream.io/static/712bb5c0bd5ed8d3fa6e5842f6cfbeed/c59de/tommaso.webp")),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.XYEEVyW_j_K9Nzh4yaRmlV8Dd2APrGi_KieLcmNhQgs")
    )
    
    static let thierry = UserCredentials(
        user: .init(id: "thierry", name: "Thierry", imageURL: URL(string: "https://getstream.io/static/237f45f28690696ad8fff92726f45106/c59de/thierry.webp")),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGhpZXJyeSJ9.RKhJvQYxpu0jk-6ijt4Pkp4wDexLhTUdBDB56qodQ6Q")
    )
    
    static let marcelo = UserCredentials(
        user: .init(id: "marcelo", name: "Marcelo", imageURL: URL(string: "https://getstream.io/static/aaf5fb17dcfd0a3dd885f62bd21b325a/802d2/marcelo-pires.webp")),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFyY2VsbyJ9.lM_lJBxac1KHaEaDWYLP7Sr4r1u3xsry3CclTeihrYE")
    )
    
    static let kanat = UserCredentials(
        user: .init(id: "kanat", name: "Kanat"),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoia2FuYXQifQ.P7rVVPHX4d21HpP6nvEQXiTKlJdFh7_YYZUP3rZB_oA")
    )
    
    static let toomas = UserCredentials(
        user: .init(id: "toomas", name: "Toomas"),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9vbWFzIn0.c0YPLh9Q8l_mvgaTVEh9_w_qJW3m_C_dXL2DonlH6n0")
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
