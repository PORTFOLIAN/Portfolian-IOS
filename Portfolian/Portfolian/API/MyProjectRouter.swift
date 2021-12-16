//
//  MySearchRouter.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

enum MyProjectRouter: URLRequestConvertible {
    // 검색 관련 api
    case createProject(term: ProjectArticle)
    case enterProject(projectID: String)
    case arrangeProject(searchOption: ProjectSearch)
    var baseURL: URL {
        return URL(string: API.BASE_URL + "projects/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .createProject:
            return .post
        case .enterProject, .arrangeProject:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .createProject, .arrangeProject:
            return ""
        case .enterProject(let projectId):
            return projectId
        }
    }
    
    var parameter: ProjectArticle? {
        switch self {
        case let .createProject(term):
            return term
        default:
            return nil
        }
    }
    
    var parameters: Any? {
        switch self {
        case .createProject:
            if writingOwnerTag.names == [] {
                return Project(article: parameter!, userId: "testUser1", ownerStack: "")
            } else {
                let stringTag = writingOwnerTag.names[0].rawValue
                return Project(article: parameter!, userId: "testUser1", ownerStack: stringTag)
            }
        case .enterProject:
            return nil
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
        case .createProject:
            request = try JSONParameterEncoder().encode(parameters as? Project, into: request)
        case .enterProject:
            return request
        case .arrangeProject:
            request = try URLEncodedFormParameterEncoder().encode(parameters as? ProjectSearch, into: request)
            
        }
        return request
    }
}


