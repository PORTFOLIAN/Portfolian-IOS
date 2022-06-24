//
//  SocketIOManger.swift
//  Portfolian
//
//  Created by 이상현 on 2022/03/15.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    var manager = SocketManager(socketURL: URL(string: "https://api.portfolian.site:443")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    var myChat = [ChatType]()
    
    override init() {
        super.init()
        socket = self.manager.defaultSocket
        
    }
    
    func connectCheck(completion: @escaping (Bool) -> Void) {
        self.socket.on("connection") { _, _ in
            
            completion(true)
        }
    }

    func receiveMessage(completion: @escaping (ChatType) -> Void) {
        self.socket.on("chat:receive") { (dataArray, socketAck) in
            print(dataArray)
            let data = dataArray[0] as! NSDictionary
            let chat = ChatType(chatRoomId: data["chatRoomId"] as? String ?? "", sender: data["sender"] as? String ?? "", receiver: data["receiver"] as? String ?? "", messageContent: data["messageContent"] as! String, messageType: data["messageType"] as? String ?? "", date: data["date"] as? String ?? "")
            completion(chat)
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
   
    func sendAuth() {
        socket.emit("auth", ["userId": JwtToken.shared.userId])
        print("소켓 연결")
    }
    
    func sendMessage(_ chatType: ChatType) {
        socket.emit("chat:send", ["chatRoomId" : chatType.chatRoomId, "sender" : chatType.sender, "receiver" : chatType.receiver, "messageContent" : chatType.messageContent, "date": chatType.date, "messageType" : chatType.messageType])
    }
    
    func leaveMessage(_ chatType: ChatType) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let time = dateFormatter.string(from: now)
        socket.emit("notice:leave", ["chatRoomId" : chatType.chatRoomId, "sender" : chatType.sender, "receiver" : chatType.receiver, "messageContent" : chatType.messageContent, "date": "\(time)", "messageType" : chatType.messageType])
    }
    
    func enterMessage(_ chatType: ChatType) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let time = dateFormatter.string(from: now)
        socket.emit("notice:enter", ["chatRoomId" : chatType.chatRoomId, "sender" : chatType.sender, "messageContent" : chatType.messageContent, "date": "\(time)", "messageType" : chatType.messageType])
    }
    
    func readMessage(_ roomId: String) {
        socket.emit("chat:read", ["chatRoomId" : roomId, "userId" : JwtToken.shared.userId])
    }
}

struct ChatType {
    var chatRoomId = String()
    var sender = String()
    var receiver = String()
    var messageContent = String()
    var messageType = String()
    var date = String()
    var firstChat = Bool()
}
