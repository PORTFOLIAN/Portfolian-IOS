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
        
        socket.on("receive") { dataArray, ack in
            var chat = ChatType()
            print(type(of: dataArray))
            let data = dataArray[0] as! NSDictionary
            chat.messageContent = data["messageContent"] as! String
            self.myChat.append(chat)
            print(chat)
            }
    }
    func receiveMessage(completion: @escaping (ChatType) -> Void) {
        self.socket.on("receive") { (dataArray, socketAck) in
            print("***************************************")
            print(type(of: dataArray))
            let data = dataArray[0] as! NSDictionary
            let chat = ChatType(roomId: data["roomId"] as? String ?? "", sender: data["sender"] as? String ?? "", messageContent: data["messageContent"] as! String)
            completion(chat)
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
   
    func sendMessage(_ chatType: ChatType) {
        socket.emit("send", ["roomId" : chatType.roomId, "sender" : chatType.sender, "messageContent" : chatType.messageContent])
    }
}

struct ChatType {
    var roomId = String()
    var sender = String()
    var messageContent = String()
}
