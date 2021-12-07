//
//  Project.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/30.
//

import Foundation
struct Project: Codable {
    let article: ProjectArticle
    let userId: String
    let ownerStack: String
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

struct ProjectInfo {
    let code: Int
    let projectId: String
    let title: String
    let stackList: [String]
    let subjectDescription: String
    let projectTime: String
    let recruitmentCondition: String
    let progress: String
    let description: String
    let detail: String
    let capacity: Int
    let view: Int
    let bookMark: Bool
    let status: Int
    let NickName: String
    let leaderDescription: String
    let userId: String
    let photo: String
}
var recruitWriting = RecruitWriting()
