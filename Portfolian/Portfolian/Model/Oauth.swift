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
    var accessToken: String
    var userId: String
    init() {
        self.code = 0
        self.isNew = true
        self.accessToken = ""
        self.userId = ""
    }
}

struct JwtToken {
    static var shared = JwtToken()

    var accessToken: String
    var refreshToken: String
    var userId: String
    init() {
        self.accessToken = ""
        self.refreshToken = ""
        self.userId = ""
    }
}
