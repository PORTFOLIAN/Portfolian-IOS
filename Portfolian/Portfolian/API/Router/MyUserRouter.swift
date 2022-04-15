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
    case getProfile(userId: String)
    case patchMyProfile(myInfo: UserProfile)
    case deleteUserId
    case postBookMark(bookmark: Bookmark)
    case arrangeProject
    var baseURL: URL {
        return URL(string: API.BASE_URL + "users")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .patchNickName, .patchMyProfile:
            return .patch
        case .getProfile:
            return .get
        case .deleteUserId:
            return .delete
        case .postBookMark:
            return .post
        case .arrangeProject:
            return .get
        }
    }
   
    var endPoint: String {
        switch self {
        case .patchNickName:
            return "\(JwtToken.shared.userId )/nickName"
        case .patchMyProfile:
            return "\(JwtToken.shared.userId )/info"
        case let .getProfile(userId):
            return "\(userId)/info"
        case .deleteUserId:
            return "\(JwtToken.shared.userId)"
        case .postBookMark, .arrangeProject:
            return "\(JwtToken.shared.userId )/bookMark"
        }
    }
    
    var parameter: Any? {
        switch self {
        case let .patchNickName(nickName):
            return ["nickName": nickName]
        case let .postBookMark(bookmark):
            return bookmark
        case let .patchMyProfile(myInfo):
            return [
                "nickName": myInfo.nickName,
                "description": myInfo.description,
                "github": myInfo.github,
                "mail": myInfo.mail,
            ]
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
        case .getProfile, .deleteUserId, .arrangeProject, .patchMyProfile:
            return request
        }
        return request
    }
    
    var multipartFormData: MultipartFormData {
        let multipartFormData = MultipartFormData()
        switch self {
        case let .patchMyProfile(myInfo):
            for (key, value) in parameter as! Parameters {
                if value as! String != "" {
                    multipartFormData.append( "\(value)".data(using: String.Encoding.utf8)!  , withName: key)
                }
            }
            for value in myInfo.stack {
                multipartFormData.append( "\(value)".data(using: String.Encoding.utf8)!, withName: "stack")
            }
            multipartFormData.append(myInfo.photo.jpegData(compressionQuality: 0)!, withName: "photo", fileName: "profile.jpeg", mimeType: "image/jpeg")
        default:
            break
        }
        return multipartFormData
    }
}

