//
//  Project.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/30.
//

import Foundation
import KakaoSDKTalk
struct Project: Codable {
    let article: ProjectArticle
    let userId: String
    let ownerStack: String
}

struct ProjectSearch: Codable{
    let stackList: String
    let sort: String
    let keyword: String
}

struct ProjectArticle: Codable {
    var title: String?
    var stackList: [String]?
    var subjectDescription: String?
    var projectTime: String?
    var condition: String?
    var progress: String?
    var description: String?
    var capacity: Int?
}

struct RecruitWriting {
    var code: Int
    var message: String
    var newProjectID: String
    init() {
        self.code = Int()
        self.message = String()
        self.newProjectID = String()
    }
}

struct ProjectInfo : Codable {
    let code: Int
    let projectId: String
    let title: String
    let capacity: Int
    let view: Int
    let bookMark: Bool
    let status: Int
    let stackList: [String]
    let contents: Contents
    let leader: Leader
    struct Contents: Codable {
        let subjectDescription: String
        let projectTime: String
        let recruitmentCondition: String
        let progress: String
        let description: String
    }
    struct Leader: Codable {
        let userId: String
        let nickName: String
        let description: String
        let stack: String
        let photo: String
    }
}

struct ProjectListInfo : Codable {
    var articleList: [Article]
    var code: Int
    init() {
        self.articleList = [Article]()
        self.code = Int()
    }
    
    struct Article: Codable {
        let projectId: String
        let title: String
        let stackList: [String]
        let description: String
        let capacity: Int
        let view: Int
        let bookMark: Bool
        let status: Int
        
        let leader: Leader
        struct Leader: Codable {
            let userId: String
            let photo: String
        }
    }
}


var recruitWriting = RecruitWriting()
var projectListInfo = ProjectListInfo()
