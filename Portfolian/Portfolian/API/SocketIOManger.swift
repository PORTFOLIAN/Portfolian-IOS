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
    var manager = SocketManager(socketURL: URL(string: "http://api.portfolian.site:3001")!, config: [.log(true), .compress])
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

    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
   
    func sendMessage(_ chatType: ChatType) {
        socket.emit("send", ["roomId" : chatType.roomId, "messageContent" : chatType.messageContent])
    }
}

struct ChatType {
    var roomId = String()
    var messageContent = String()
}
