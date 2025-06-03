//
//  LoginView.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 9.5.25.
//

import SwiftUI
import StreamCore

struct LoginView: View {
    
    var onUserSelected: (UserCredentials) -> ()
    
    var body: some View {
        VStack {
            ForEach(UserCredentials.builtIn) { credentials in
                Button {
                    onUserSelected(credentials)
                } label: {
                    Text("Login as \(credentials.user.name)")
                }
                .padding()
            }
        }
    }
}

struct UserCredentials: Identifiable {
    let user: User
    let token: UserToken
    var id: String {
        user.id
    }
}

extension UserCredentials {
    static let builtIn: [UserCredentials] = [.martin, .tommaso, .thierry, .marcelo, .toomas]
    
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
    
    static let toomas = UserCredentials(
        user: .init(id: "toomas", name: "Toomas"),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9vbWFzIn0.c0YPLh9Q8l_mvgaTVEh9_w_qJW3m_C_dXL2DonlH6n0")
    )
    
    var fid: String {
        "user:\(id)"
    }
    
    static func credentials(for id: String) -> UserCredentials {
        switch id {
        case "martin": return .martin
        case "thierry": return .thierry
        case "marcelo": return .marcelo
        case "toomas": return .toomas
        default: return .tommaso
        }
    }
}
