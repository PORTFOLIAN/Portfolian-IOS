//
//  MySearchRouter.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import Alamofire
import UIKit
import SwiftyJSON

enum MyProjectRouter: URLRequestConvertible {
    // 검색 관련 api
    case createProject(term: ProjectArticle)
    case enterProject(projectID: String)
    case arrangeProject(searchOption: ProjectSearch)
    case deleteProject(projectID: String)
    case putProject(term: ProjectArticle)
    case putFinishProject(projectID: String, complete: Bool)
    var baseURL: URL {
        return URL(string: API.BASE_URL + "projects/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .createProject:
            return .post
        case .enterProject, .arrangeProject:
            return .get
        case .putProject, .putFinishProject:
            return .put
        case .deleteProject:
            return .delete
        }
    }
    
    var endPoint: String {
        switch self {
        case .createProject, .arrangeProject:
            return ""
        case .enterProject(let projectID), .deleteProject(let projectID):
            return projectID
        case .putFinishProject(let projectID, _):
            return "\(projectID)/status"
        case .putProject:
            return recruitWriting.newProjectID
        }
    }
    
    var parameter: ProjectArticle? {
        switch self {
        case let .createProject(term):
            return term
        case let .putProject(term):
            return term
        default:
            return nil
        }
    }
    
    var parameters: Any? {
        switch self {
        case .createProject, .putProject:
            if writingOwnerTag.names != [] {
                let stringTag = writingOwnerTag.names[0].rawValue
            return Project(article: parameter!, userId: JwtToken.shared.userId , ownerStack: stringTag)
            } else {
                return Project(article: parameter!, userId: JwtToken.shared.userId , ownerStack: "")
            }
        case .enterProject, .deleteProject:
            return nil
        case let .putFinishProject(_, complete):
            let intValue = complete == true ? 1 : 0
            return ["status" : intValue]
        case .arrangeProject(let searchOption):
            return searchOption
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url  = baseURL.appendingPathComponent(endPoint)
        print("MyProjectRouter - asURLRequest() url : \(url)")
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        case .createProject, .putProject:
            request = try JSONParameterEncoder().encode(parameters as? Project, into: request)
        case .enterProject, .deleteProject:
            return request
        case .arrangeProject:
            request = try URLEncodedFormParameterEncoder().encode(parameters as? ProjectSearch, into: request)
        case .putFinishProject:
            request = try JSONParameterEncoder().encode(parameters as? [String:Int], into: request)
        }
        return request
    }
}


