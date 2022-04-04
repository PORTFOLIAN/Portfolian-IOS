//
//  Chat.swift
//  Portfolian
//
//  Created by 이상현 on 2022/04/03.
//

import Foundation

struct ChatMessageList: Codable {
    let code: Int
    let message: String
    var chatList: [Chat]
    init() {
        self.code = 0
        self.message = ""
        self.chatList = [Chat]()
    }
}

struct Chat: Codable {
    let chatType: String
    let senderId: String
    let messageContents: String
    let date: String
}

struct ChatRoomList: Codable {
    let code: Int
    let message: String
    let chatRoomList: [ChatRoom]
    
    init() {
        code = 0
        message = ""
        chatRoomList = [ChatRoom]()
    }
}
struct ChatRoom: Codable {
    let chatRoomId: String
    let projectTitle: String
    let newChatCnt: Int
    let newChatContent: String
    let newChatDate: String
    let user: UserInfo
    init() {
        chatRoomId = ""
        projectTitle = ""
        newChatCnt = 0
        newChatContent = ""
        newChatDate = ""
        user = UserInfo()
    }
    
}
struct UserInfo: Codable {
    let userId: String
    let nickName: String
    let photo: String
    init() {
        userId = ""
        nickName = ""
        photo = ""
    }
}

var chatRoom = ChatRoom()
