//
//  MySearchRouter.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import Foundation
import Alamofire
import UIKit


struct ProjectArticle: Codable {
    let title: String?
    let stackList: [String]?
    let subjectDescription: String?
    let projectTime: String?
    let condition: String?
    let progress: String?
    let description: String?
    let capacity: Int?
}

enum MyProjectRouter: URLRequestConvertible {
    // 검색 관련 api
    struct Project: Codable {
        let article: ProjectArticle
        let userId: String
        let ownerStack: String
    }
    
    case createProject(term: ProjectArticle)
//    case searchUsers(term: String)
    var baseURL: URL {
        return URL(string: API.BASE_URL + "projects/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .createProject:
            return .post
//        case .searchUsers:
//            return .get
        }
    }
    var endPoint: String {
        switch self {
        case .createProject:
            return ""
//        case .searchUsers:
//            return "users/"
        }
    }
    
    var parameter : ProjectArticle {
        switch self {
        case let .createProject(term):
            return term
        }
    }
    
    var parameters : Project {
        let stringTag = writingOwnerTag.names[0].rawValue
        
        return Project(article: parameter, userId: "testUser1", ownerStack: stringTag)
    }
    
    func asURLRequest() throws -> URLRequest {
        let url  = baseURL.appendingPathComponent(endPoint)
        print("MyProjectRouter - asURLRequest() url : \(url)")
        var request = URLRequest(url: url)
        request.method = method
        

        request = try JSONParameterEncoder().encode(parameters, into: request)
        return request
    }
}

