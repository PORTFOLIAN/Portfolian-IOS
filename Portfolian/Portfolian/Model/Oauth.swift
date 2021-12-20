//
//  Oauth.swift
//  Portfolian
//
//  Created by 이상현 on 2021/12/20.
//

import Foundation

struct Jwt: Codable {
    static var shared = Jwt()
    let code: Int
    let isNew: Bool
    var refreshToken: String
    var accessToken: String
    let userId: String
    init() {
        self.code = 0
        self.isNew = true
        self.refreshToken = ""
        self.accessToken = ""
        self.userId = ""
    }
}



