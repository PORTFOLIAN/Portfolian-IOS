//
//  ChatRoomViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2022/03/22.
//

import UIKit
import SocketIO
import SnapKit
import Then

class ChatRoomViewController: UIViewController {
    lazy var tableView = UITableView().then { make in
        make.register(MyChatCell.self, forCellReuseIdentifier: "MyChatCell")
        make.register(YourChatCell.self, forCellReuseIdentifier: "YourChatCell")
    }
    
    var footerView = UIView()
    
    var textView = UITextView().then { UITextView in
        UITextView.backgroundColor = .white
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 18)
        UITextView.layer.cornerRadius = 20
    }
    
    var sendButton = UIButton().then { UIButton in
        UIButton.setImage(UIImage(named: "Send"), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    var myChat: [ChatType] = []
    
    var socket: SocketIOClient!
    
    @objc func buttonPressed(_ sender: UIButton) {
        if textView.text != "" {
            let chat = ChatType(roomId: "\(Jwt.shared.userId) - 상대UID", sender: "\(Jwt.shared.userId)", messageContent: textView.text)
            SocketIOManager.shared.sendMessage(chat)
            myChat.append(chat)
            updateChat(count: myChat.count) {
                print("채팅 송신")
            }
        }
    }
    
    var footerViewBottomConstraint: Constraint? = nil
    
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    // NS_을 사용할 때는 objc
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        // duration 애니메이션이 지속되는 초단위
        // userInfo가 있다면 keyboardAnimationDurationUserInfoKey를 이용해서 값을 가져온다. 0
        let curve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        // Curve
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        // userInfo가 있다면 keyboardFrameEndUserInfoKey를 이용해서 값을 가져온다. {{0, 553}, {390, 291}}
        let keyboardHeight = keyboardFrame.size.height

        self.footerViewBottomConstraint?.update(inset: keyboardHeight - self.view.safeAreaInsets.bottom)
        UIView.animate(withDuration: duration, delay: 0, options: [UIView.AnimationOptions(rawValue: curve)], animations: { [self] in
            self.view.layoutIfNeeded()
        }) { iscompleted in
            if iscompleted {
                if !self.myChat.isEmpty {
                    let lastIndex = IndexPath(row: self.myChat.count - 1, section: 0)
                    self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
                }
            }
        }
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    // NS_을 사용할 때는 objc
    @objc func keyboardWillHide(_ notification: NSNotification){
        let userInfo = notification.userInfo
        // NSNumber로 가져와 값의 형태를 바꿔줄 수도 있다.
        let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        
        self.footerViewBottomConstraint?.update(inset: 0)
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: [UIView.AnimationOptions(rawValue: UInt(curve.intValue))], animations: { [self] in
            self.view.layoutIfNeeded()
        })
    }
    
    // 채팅 업데이트
    func updateChat(count: Int, completion: @escaping() -> Void) {
        let indexPath = IndexPath( row: count-1, section: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: .none)
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        // 필요한경우 escaping closure를 이용한 데이터 전달
        completion()
    }
    
    // 서버로부터 메시지 받을때 채팅창 업데이트
    func bindMsg() {
        SocketIOManager.shared.receiveMessage() { chat in
            self.myChat.append(chat)
            self.updateChat(count: self.myChat.count) {
                print("Get Message") }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SocketIOManager.shared.closeConnection()
        socket = SocketIOManager.shared.socket
        SocketIOManager.shared.establishConnection()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        
        hideKeyboard()
        bindMsg()

        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(textView)
        footerView.addSubview(sendButton)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(footerView.snp.top).constraint
        }
        footerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(50)
            footerViewBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        textView.snp.makeConstraints { make in
            make.centerY.equalTo(footerView)
            make.leading.equalTo(footerView).offset(10)
            make.trailing.equalTo(sendButton.snp.leading)
            make.height.equalTo(40)
        }
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(footerView)
            make.trailing.equalTo(footerView).offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        footerView.backgroundColor = .systemGray5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        removeKeyboardNotifications()
    }
}

extension ChatRoomViewController: UITableViewDelegate {
}

extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = self.myChat[indexPath.row].sender == Jwt.shared.userId ? "MyChatCell" : "YourChatCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if cellId == "MyChatCell" {
            if let myChatCell = cell as? MyChatCell {
                myChatCell.chatLabel.text = self.myChat[indexPath.row].messageContent
            }
        } else {
            if let yourChatCell = cell as? YourChatCell {
                yourChatCell.chatLabel.text = self.myChat[indexPath.row].messageContent
            }
        }
        return cell
    }
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//        footerView.frame.origin.y = view.bounds.height - keyboardHeight - footerView.bounds.height
//        let activeRect = tableView.convert(tableView.bounds, to: tableView)
//        print(activeRect)
//        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
//        tableView.contentInset = contentInsets
//        tableView.verticalScrollIndicatorInsets = contentInsets
//        let activeRect = tableView.convert(tableView.bounds, to: tableView)
//        tableView.scrollRectToVisible(activeRect, animated: true)
//        tableView.verticalScrollIndicatorInsets.bottom = -keyboardHeight

//        footerView.frame.origin.y = view.bounds.height - view.safeAreaInsets.bottom - footerView.bounds.height
//        tableView.contentInset = UIEdgeInsets.zero
//        tableView.verticalScrollIndicatorInsets = tableView.contentInset



