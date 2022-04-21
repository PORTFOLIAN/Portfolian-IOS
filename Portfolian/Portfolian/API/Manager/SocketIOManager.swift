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
    
    func receiveMessage(completion: @escaping (ChatType) -> Void) {
        self.socket.on("chat:receive") { (dataArray, socketAck) in            
            print("***************************************")
            print(dataArray)
            let data = dataArray[0] as! NSDictionary
            let chat = ChatType(roomId: data["roomId"] as? String ?? "", sender: data["sender"] as? String ?? "", receiver: data["receiver"] as? String ?? "", messageContent: data["messageContent"] as! String, date: data["date"] as! String)
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
    }
    
    func sendMessage(_ chatType: ChatType) {
        socket.emit("chat:send", ["roomId" : chatType.roomId, "sender" : chatType.sender, "receiver" : chatType.receiver, "messageContent" : chatType.messageContent, "date": "\(chatType.date)"])
    }
    
    func leaveMessage(_ chatType: ChatType) {
        socket.emit("notice:leave", ["roomId" : chatType.roomId, "sender" : chatType.sender, "receiver" : chatType.receiver, "messageContent" : chatType.messageContent, "date": "\(chatType.date)"])
    }
    
    func enterMessage(_ chatType: ChatType) {
        socket.emit("notice:enter", ["roomId" : chatType.roomId, "sender" : chatType.sender, "messageContent" : chatType.messageContent, "date": "\(chatType.date)"])
    }
}

struct ChatType {
    var roomId = String()
    var sender = String()
    var receiver = String()
    var messageContent = String()
    var date = String()
}
