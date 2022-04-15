//
//  File.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/18.
//

import Foundation
import Alamofire

struct User: Codable {
    let userId : String
    let nickName : String
    let description : String
    let stackList : [String]
    let photo : String
    let github : String
    let mail : String
    
    init() {
        userId = String()
        nickName = String()
        description = String()
        stackList = [String]()
        photo = String()
        github = String()
        mail = String()
    }
}

struct Bookmark: Codable {
    var projectId: String
    var bookMarked: Bool
}

struct UserProfile {
    var nickName : String
    var description : String
    var stack : [String]
    var photo : UIImage
    var github : String
    var mail : String
    
//    init() {
//        nickName = String()
//        description = String()
//        stack = [String]()
//        photo = UIImage()
//        github = String()
//        mail = String()
//    }
}


