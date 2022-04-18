//
//  MyKakaoRouter.swift
//  Portfolian
//
//  Created by 이상현 on 2021/12/20.
//

import Alamofire
import UIKit
import SwiftyJSON

enum MyOauthRouter: URLRequestConvertible {
    // auth 관련 api
    case postKaKaoToken(token: String)
    case postRefreshToken
    case patchLogout
    var baseURL: URL {
        return URL(string: API.BASE_URL + "oauth")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .postKaKaoToken, .postRefreshToken:
            return .post
        case .patchLogout:
            return .patch
        }
    }
    
    var endPoint: String {
        switch self {
        case .postKaKaoToken:
            return "kakao/access"
        case .postRefreshToken:
            return "refresh"
        case .patchLogout:
            return "logout"
        }
    }
    
    var parameter: [String: String]? {
        switch self {
        case let .postKaKaoToken(token):
            return ["token": token]
        case .postRefreshToken:
            return ["userId": JwtToken.shared.userId ]
        case .patchLogout:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url  = baseURL.appendingPathComponent(endPoint)
        print("MyProjectRouter - asURLRequest() url : \(url)")
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        case .postKaKaoToken:
            request = try JSONParameterEncoder().encode(parameter, into: request)
        case .postRefreshToken:
            request = try JSONParameterEncoder().encode(parameter, into: request)
        case .patchLogout:
            return request
        }
        return request
    }
}


