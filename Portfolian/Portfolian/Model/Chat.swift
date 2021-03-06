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
    var chatList: ChatLists
    init() {
        self.code = 0
        self.message = ""
        self.chatList = ChatLists()
    }
}

struct ChatLists: Codable {
    let newChatList: [NewChatList]
    let oldChatList: [OldChatList]
    
    struct NewChatList: Codable {
        let sender: String?
        let messageContent: String
        let messageType: String
        let date: String
    }

    struct OldChatList: Codable {
        let sender: String?
        let messageContent: String
        let messageType: String
        let date: String
    }
    
    init() {
        self.oldChatList = [OldChatList]()
        self.newChatList = [NewChatList]()
    }
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
