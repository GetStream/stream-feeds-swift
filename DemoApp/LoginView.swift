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
            Button {
                onUserSelected(.martin)
            } label: {
                Text("Login as Martin")
            }
            .padding()
            
            Button {
                onUserSelected(.tommaso)
            } label: {
                Text("Login as Tommaso")
            }
            .padding()
        }
    }
}

struct UserCredentials {
    let user: User
    let token: UserToken
}

extension UserCredentials {
    static let martin = UserCredentials(
        user: .init(id: "martin", name: "Martin", imageURL: URL(string: "https://getstream.io/static/2796a305dd07651fcceb4721a94f4505/802d2/martin-mitrevski.webp")),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFydGluIn0.-8mL49OqMdlvzXR_1IgYboVXXuXFc04r0EvYgko-X8I")
    )
    
    static let tommaso = UserCredentials(
        user: .init(id: "tommaso", name: "Tommaso", imageURL: URL(string: "https://getstream.io/static/712bb5c0bd5ed8d3fa6e5842f6cfbeed/c59de/tommaso.webp")),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.XYEEVyW_j_K9Nzh4yaRmlV8Dd2APrGi_KieLcmNhQgs")
    )
    
    static func credentials(for id: String) -> UserCredentials {
        if id == "martin" {
            return .martin
        } else {
            return .tommaso
        }
    }
}
