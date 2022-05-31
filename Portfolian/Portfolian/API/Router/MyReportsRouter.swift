//
//  MyReportsRouter.swift
//  Portfolian
//
//  Created by 이상현 on 2022/05/31.
//

import Alamofire
import UIKit
import SwiftyJSON

enum MyReportsRouter: URLRequestConvertible {
    case postReportProject(projectID: String, reason: String)
    case postReportUser(userId: String, reason: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "reports/")!
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var endPoint: String {
        switch self {
        case let .postReportUser(userId, _):
            return "users/\(userId)"
        case let .postReportProject(projectID, _):
            return "projects/\(projectID)"
        }
    }
    
    var parameter: [String: String] {
        switch self {
        case let .postReportProject(_, reason), let .postReportUser(_, reason):
            return ["reason":reason]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url  = baseURL.appendingPathComponent(endPoint)
        print("MyProjectRouter - asURLRequest() url : \(url)")
        var request = URLRequest(url: url)
        request.method = method
        request = try JSONParameterEncoder().encode(parameter, into: request)
        return request
    }
}


