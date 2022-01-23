//
//  File.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/18.
//

import Foundation
import Alamofire

struct User: Codable {
    static let shared = User(userId: String(), nickName: String(), description: String(), stackList: [String](), photo: String(), github: String(), mail: String())
//    let code: Int // 수정해야됨
    let userId : String
    let nickName : String
    let description : String
    let stackList : [String]
    let photo : String
    let github : String
    let mail : String
}

struct Bookmark: Codable {
    var projectId: String
    var bookMarked: Bool
}


