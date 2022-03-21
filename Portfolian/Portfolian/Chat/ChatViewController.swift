//
//  ChatViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/19.
//

import UIKit
import SnapKit
import Then
import SocketIO

class ChatViewController: UIViewController {
    lazy var messageLabel = UILabel().then { label in
        label.text = "채팅"
        label.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    lazy var sendTextField1 = UITextField().then { UITextField in
        UITextField.placeholder = "보내보삼"
        UITextField.leftViewMode = .always
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var sendTextField2 = UITextField().then { UITextField in
        UITextField.placeholder = "보내보삼"
        UITextField.leftViewMode = .always
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var sendTextField3 = UITextField().then { UITextField in
        UITextField.placeholder = "보내보삼"
        UITextField.leftViewMode = .always
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var connectSocketButton = UIButton().then { UIButton in
        UIButton.setTitle("소켓 연결", for: .normal)
        UIButton.setTitleColor(.black, for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var disconnectSocketButton = UIButton().then { UIButton in
        UIButton.setTitle("소켓 종료", for: .normal)
        UIButton.setTitleColor(.black, for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var sendSocketButton1 = UIButton().then { UIButton in
        UIButton.setTitle("전송", for: .normal)
        UIButton.setTitleColor(.black, for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var sendSocketButton2 = UIButton().then { UIButton in
        UIButton.setTitle("전송", for: .normal)
        UIButton.setTitleColor(.black, for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var sendSocketButton3 = UIButton().then { UIButton in
        UIButton.setTitle("전송", for: .normal)
        UIButton.setTitleColor(.black, for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    var chatType = ChatType()

    @objc func buttonPressed(_ sender: UIButton) {
        switch sender {
        case connectSocketButton:
            SocketIOManager.shared.establishConnection()
        case disconnectSocketButton:
            SocketIOManager.shared.closeConnection()
        case sendSocketButton1:
            if (sendTextField1.text != nil) {
                chatType.messageContent = sendTextField1.text!
                chatType.roomId = "test1"
            }
            SocketIOManager.shared.sendMessage(chatType)
        case sendSocketButton2:
            if (sendTextField2.text != nil) {
                chatType.messageContent = sendTextField2.text!
                chatType.roomId = "test2"
            }
            SocketIOManager.shared.sendMessage(chatType)
        case sendSocketButton3:
            if (sendTextField3.text != nil) {
                chatType.messageContent = sendTextField3.text!
                chatType.roomId = "test3"
            }
            SocketIOManager.shared.sendMessage(chatType)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(messageLabel)
        view.addSubview(disconnectSocketButton)
        view.addSubview(connectSocketButton)
        view.addSubview(sendSocketButton1)
        view.addSubview(sendSocketButton2)
        view.addSubview(sendSocketButton3)

        view.addSubview(sendTextField1)
        view.addSubview(sendTextField2)
        view.addSubview(sendTextField3)
        messageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        connectSocketButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(messageLabel)
            make.height.equalTo(20)
        }
        disconnectSocketButton.snp.makeConstraints { make in
            make.top.equalTo(connectSocketButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(connectSocketButton)
            make.height.equalTo(20)
        }
        
        sendTextField1.snp.makeConstraints { make in
            make.top.equalTo(disconnectSocketButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(disconnectSocketButton)
            make.height.equalTo(20)
        }
        sendSocketButton1.snp.makeConstraints { make in
            make.top.equalTo(sendTextField1.snp.bottom).offset(10)
            make.leading.trailing.equalTo(sendTextField1)
            make.height.equalTo(20)
        }
        sendTextField2.snp.makeConstraints { make in
            make.top.equalTo(sendSocketButton1.snp.bottom).offset(10)
            make.leading.trailing.equalTo(sendSocketButton1)
            make.height.equalTo(20)
        }
        sendSocketButton2.snp.makeConstraints { make in
            make.top.equalTo(sendTextField2.snp.bottom).offset(10)
            make.leading.trailing.equalTo(sendTextField2)
            make.height.equalTo(20)
        }
        sendTextField3.snp.makeConstraints { make in
            make.top.equalTo(sendSocketButton2.snp.bottom).offset(10)
            make.leading.trailing.equalTo(sendSocketButton2)
            make.height.equalTo(20)
        }
        sendSocketButton3.snp.makeConstraints { make in
            make.top.equalTo(sendTextField3.snp.bottom).offset(10)
            make.leading.trailing.equalTo(sendTextField3)
            make.height.equalTo(20)
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
