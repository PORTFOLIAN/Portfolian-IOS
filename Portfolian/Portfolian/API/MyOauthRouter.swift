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
    // 검색 관련 api
    case postKaKaoToken(token: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "oauth")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .postKaKaoToken:
            return .post
        
        }
    }
    
    var endPoint: String {
        switch self {
        case .postKaKaoToken:
            return"kakao/access"
        }
    }
    
    var parameter: [String: String]? {
        switch self {
        case let .postKaKaoToken(token):
            return ["token": token]
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
        case .postKaKaoToken:
            request = try JSONParameterEncoder().encode(parameter, into: request)
        }
        return request
    }
}

