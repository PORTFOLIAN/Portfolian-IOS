//
//  SocketIOManager.swift
//  Portfolian
//
//  Created by 이상현 on 2022/01/03.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var manager = SocketManager(socketURL: URL(string: SocketIO.BASE_URL)!)
    var socket: SocketIOClient!
    override init() {
        super.init()
        socket = self.manager.defaultSocket
//        socket.on("receive") { dataArray, ack in print(dataArray) }
        sendMessage(message: "abc", nickname: "ab")
    }
    
    func establishConnection() {
        socket.connect()
        
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    func sendMessage(message: String, nickname: String) {
        socket.emit("connection", ["nick": nickname, "msg" : message])
        
        
    }

    
//    func connectToServerWithNickname(nickname: String, completionHandler: (userList: [[String: AnyObject]]!) -> Void) {
//        socket.emit("connectUser", nickname)
//        socket.on("userList") { ( dataArray, ack) -> Void in
//               completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
//           }
//
//    }

    
//    func sendMessage(message: String, nickname: String) {
//        socket.emit("msg", ["nick": nickname, "msg" : message])
//    }
}
