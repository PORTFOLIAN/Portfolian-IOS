//
//  MySearchRouter.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import Foundation
import Alamofire

// 검색 관련 api

enum MySearchRouter: URLRequestConvertible {
case searchPhotos(term: String)
case searchUsers(term: String)
    var baseURL: URL {
        return URL(string: API.BASE_URL + "search/")!
    }
    
    var method: HTTPMethod {
        
//                return .get
                switch self {
                case .searchPhotos, .searchUsers:
                    return .get
                }
//                switch self {
//                case .sarchPhotos:
//                    return .get
//                case .searchUsers:
//                    return .post
//                }
    }
    var endPoint: String {
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    var parameters : [String : String] {
        switch self {
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query" : term]
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url  = baseURL.appendingPathComponent(endPoint)
        print("MySearchRouter - asURLRequest() url : \(url)")
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        return request
        
        
    }
}

