//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

struct DemoAppConfig: Sendable {
    let apiKey: String
    var tokenForUser: @Sendable (String) -> String
}

extension DemoAppConfig {
    static let staging = DemoAppConfig(
        apiKey: "pd67s34fzpgw",
        tokenForUser: { userId in
            switch userId {
            case "luke_skywalker":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibHVrZV9za3l3YWxrZXIifQ.hZ59SWtp_zLKVV9ShkqkTsCGi_jdPHly7XNCf5T_Ev0"
            case "martin":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFydGluIn0.ZDox0RWqhKhhK2lrbUVJvf8Zd9PVA_NX5dGMVC6mcSg"
            case "tommaso":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.DNR3Gnkj1nrwIbLkfgWLzf9Rgx23Hj4qt5jItHKH8hU"
            case "thierry":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGhpZXJyeSJ9.XJEWIVxe_-2E9XEFQo01nW7UgYijx5LzyAkbY34o0Pw"
            case "marcelo":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFyY2VsbyJ9.ee6WC94jyfQbafJr9FLEc_ZgKDjYNxvz6e_z-phP8UY"
            case "kanat":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoia2FuYXQifQ.ma7L8U6an92ECUHaD6mxesZvKX4TjfZndJ8uKGR2ic4"
            case "toomas":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9vbWFzIn0.PBdUgu0w73UBa29ckt5AMMfmCK0VsOf0f0_aCgum3lc"
            default:
                ""
            }
        }
    )
    
    static let localhost = DemoAppConfig(
        apiKey: "892s22ypvt6m",
        tokenForUser: { userId in
            switch userId {
            case "luke_skywalker":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibHVrZV9za3l3YWxrZXIifQ.hZ59SWtp_zLKVV9ShkqkTsCGi_jdPHly7XNCf5T_Ev0"
            case "martin":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFydGluIn0.-8mL49OqMdlvzXR_1IgYboVXXuXFc04r0EvYgko-X8I"
            case "tommaso":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.XYEEVyW_j_K9Nzh4yaRmlV8Dd2APrGi_KieLcmNhQgs"
            case "thierry":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGhpZXJyeSJ9.RKhJvQYxpu0jk-6ijt4Pkp4wDexLhTUdBDB56qodQ6Q"
            case "marcelo":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFyY2VsbyJ9.lM_lJBxac1KHaEaDWYLP7Sr4r1u3xsry3CclTeihrYE"
            case "kanat":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoia2FuYXQifQ.P7rVVPHX4d21HpP6nvEQXiTKlJdFh7_YYZUP3rZB_oA"
            case "toomas":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9vbWFzIn0.c0YPLh9Q8l_mvgaTVEh9_w_qJW3m_C_dXL2DonlH6n0"
            default:
                ""
            }
        }
    )
    
    static let production = DemoAppConfig(
        apiKey: "fa5xpkvxrdw4",
        tokenForUser: { userId in
            switch userId {
            case "luke_skywalker":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibHVrZV9za3l3YWxrZXIifQ.zuAJWZfZWPFJYYItt1QQnUl2IlTq6PcBPStrcD_U91A"
            case "martin":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFydGluIn0.w4IhPDZXHTnY_JTZqT5f75TpZ-Qq5gFgXHM8-mkjYjg"
            case "tommaso":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.3sl5XZMbSVvBfJhoT6islSfNMlPU46uZeKr_UCFESWY"
            case "thierry":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGhpZXJyeSJ9.2vI4zX2WB6zlSZQdAwLqwRo8RRTPMDKLQF3lNJTiIG8"
            case "marcelo":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFyY2VsbyJ9.JGUi40Ew7SyrGab1AAr0pIXPKfqVMTiyPJPCs8EFaVY"
            case "kanat":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoia2FuYXQifQ.J7N5-RSAStR8UF3g7ce-fSSgBSLTszr5St3MwFBujfs"
            case "toomas":
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9vbWFzIn0.JOSpmeEbwIdVu1SoT7y4dZknkbQE_fEDQn5mac9yzU0"
            default:
                ""
            }
        }
    )
    
    static let current: DemoAppConfig = .production
}
