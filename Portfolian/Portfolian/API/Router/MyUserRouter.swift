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
    case patchMyDefaultPhoto
    case patchMyPhoto(image: UIImage)
    case deleteUserId
    case postBookMark(bookmark: Bookmark)
    case arrangeProject
    case patchFcm(fcm: String)
    var baseURL: URL {
        return URL(string: API.BASE_URL + "users")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .patchNickName, .patchMyProfile, .patchMyDefaultPhoto, .patchMyPhoto, .patchFcm:
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
            return "\(JwtToken.shared.userId)/nickName"
        case .patchFcm:
            return "\(JwtToken.shared.userId)/fcm"
        case .patchMyProfile:
            return "\(JwtToken.shared.userId)/info"
        case let .getProfile(userId):
            return "\(userId)/info"
        case .deleteUserId:
            return "\(JwtToken.shared.userId)"
        case .postBookMark, .arrangeProject:
            return "\(JwtToken.shared.userId)/bookMark"
        case .patchMyDefaultPhoto:
            return "\(JwtToken.shared.userId)/profile/default"
        case .patchMyPhoto:
            return "\(JwtToken.shared.userId)/profile"
        }
    }
    
    var parameter: Any? {
        switch self {
        case let .patchNickName(nickName):
            return ["nickName": nickName, "fcmToken": ""]
        case let .postBookMark(bookmark):
            return bookmark
        case let .patchMyProfile(myInfo):
            return myInfo
        case let .patchFcm(fcm):
            return ["fcmToken": fcm]
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
        case .patchMyProfile:
            request = try JSONParameterEncoder().encode(parameter as? UserProfile, into: request)
        case .patchFcm:
            request = try JSONParameterEncoder().encode(parameter as? [String:String], into: request)
        case .getProfile, .deleteUserId, .arrangeProject, .patchMyDefaultPhoto, .patchMyPhoto:
            return request
        }
        return request
    }
    
    var multipartFormData: MultipartFormData {
        let multipartFormData = MultipartFormData()
        switch self {
        case let .patchMyPhoto(image):
            multipartFormData.append(image.jpegData(compressionQuality: 0)!, withName: "photo", fileName: "profile.jpeg", mimeType: "image/jpeg")
        default:
            break
        }
        return multipartFormData
    }
}

