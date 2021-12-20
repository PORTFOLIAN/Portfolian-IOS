//
//  MyUserRouter.swift
//  Portfolian
//
//  Created by 이상현 on 2021/12/21.
//

import Alamofire
import UIKit
import SwiftyJSON

enum MyUserRouter: URLRequestConvertible {
    // 검색 관련 api
    case patchNickName(nickName: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "users")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .patchNickName:
            return .patch
        }
    }
   
    var endPoint: String {
        switch self {
        case .patchNickName:
            return "\(Jwt.shared.userId)/nickName"
        }
    }
    
    var parameter: [String: String]? {
        switch self {
        case let .patchNickName(nickName):
            return ["nickName": nickName]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url  = baseURL.appendingPathComponent(endPoint)
        print("MyProjectRouter - asURLRequest() url : \(url)")
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        case .patchNickName:
            request = try JSONParameterEncoder().encode(parameter, into: request)
            
        }
        return request
    }
}


