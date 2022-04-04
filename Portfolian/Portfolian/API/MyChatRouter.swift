//
//  MyChatRouter.swift
//  Portfolian
//
//  Created by 이상현 on 2022/04/02.
//

import Alamofire
import UIKit
import SwiftyJSON

enum MyChatRouter: URLRequestConvertible {
    // 검색 관련 api
    case postChatRoom(userId: String, projectId: String)
    case getChatRoomList
    case getChatMessageList(chatRoomId: String)
    case putChatRoom(chatRoomId: String)

    var baseURL: URL {
        return URL(string: API.BASE_URL + "chats")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .postChatRoom:
            return .post
        case .getChatMessageList, .getChatRoomList:
            return .get
        case .putChatRoom:
            return .put
        }
    }
   
    var endPoint: String {
        switch self {
        case .postChatRoom, .getChatRoomList:
            return ""
        case let .putChatRoom(chatRoomId), let .getChatMessageList(chatRoomId):
            return chatRoomId
        }
    }
    
    var parameter: Any? {
        switch self {
        case let .postChatRoom(userId, projectId):
            return [
                "userId": userId,
                "projectId": projectId
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
        case .postChatRoom:
            request = try JSONParameterEncoder().encode(parameter as? [String : String], into: request)
        default:
            return request
        }
        return request
    }
}

