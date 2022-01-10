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
    case getMyProfile
    case deleteUserId
    case postBookMark(bookmark: Bookmark)
    var baseURL: URL {
        return URL(string: API.BASE_URL + "users")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .patchNickName:
            return .patch
        case .getMyProfile:
            return .get
        case .deleteUserId:
            return .delete
        case .postBookMark:
            return .post
        }
    }
   
    var endPoint: String {
        switch self {
        case .patchNickName:
            return "\(Jwt.shared.userId)/nickName"
        case .getMyProfile:
            print(Jwt.shared.userId)
            return "\(Jwt.shared.userId)/info"
        case .deleteUserId:
            return "\(Jwt.shared.userId)"
        case .postBookMark:
            return "\(Jwt.shared.userId)/bookMark"
        }
    }
    
    var parameter: Any? {
        switch self {
        case let .patchNickName(nickName):
            return ["nickName": nickName]
        case let .postBookMark(bookmark):
            return bookmark
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
            request = try JSONParameterEncoder().encode(parameter as? [String:String], into: request)
        case .postBookMark:
            request = try JSONParameterEncoder().encode(parameter as? Bookmark, into: request)
        case .getMyProfile, .deleteUserId:
            return request
        }
        return request
    }
}


struct Bookmark: Codable {
    var projectId: String
    var bookMarked: Bool
}
//북마크로 하기
