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
    var isYourFirstChat = true
    
    var chatRoomId = String()
    var receiverId = String()
    lazy var cancelBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(buttonPressed(_:)))

    lazy var tableView = UITableView().then { make in
        make.register(MyChatCell.self, forCellReuseIdentifier: "MyChatCell")
        make.register(YourChatCell.self, forCellReuseIdentifier: "YourChatCell")
        make.register(YourProfileChatCell.self, forCellReuseIdentifier: "YourProfileChatCell")
        make.register(NoticeCell.self, forCellReuseIdentifier: "NoticeCell")
    }
    
    var headerLabel = UILabel().then { UILabel in
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UILabel.textColor = ColorPortfolian.baseBlack
        UILabel.textAlignment = .center
    }
    
    var lineViewFirst = UIView().then { UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    }
    
    var lineViewSecond = UIView().then { UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    }
    
    var footerView = UIView().then { _ in }
    
    var textView = UITextView().then { UITextView in
        UITextView.backgroundColor = .white
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 18)
        UITextView.layer.cornerRadius = 20
    }
    
    lazy var leaveBarButtonItem = UIBarButtonItem(image: UIImage(named: "leave"), style: .plain, target: self, action: #selector(buttonPressed(_:))).then { UIBarButtonItem in
        UIBarButtonItem.tintColor = ColorPortfolian.baseBlack
    }
    
    var sendButton = UIButton().then { UIButton in
        UIButton.setImage(UIImage(named: "send")?.withTintColor(ColorPortfolian.gray2, renderingMode: .alwaysOriginal), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    var myChat: [ChatType] = []
        
    var index = 0
    @objc func buttonPressed(_ sender: UIButton) {
        if sender == sendButton {
            if textView.text != "" {
                let now = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let time = dateFormatter.string(from: now)
                let chat = ChatType(chatRoomId: chatRoomId, sender: JwtToken.shared.userId, receiver: self.receiverId, messageContent: textView.text, messageType: "Chat", date: time)
                self.isYourFirstChat = true
                SocketIOManager.shared.sendMessage(chat)
                myChat.append(chat)
                updateChat(count: myChat.count) {
                }
                textView.text = ""
            }
        } else if sender == leaveBarButtonItem {
            MyAlamofireManager.shared.exitChatRoom(chatRoomId: chatRoomId, completion: { response in
                switch response {
                case .success():
                    self.navigationController?.popViewController(animated: true)
                case let .failure(myError):
                    print(myError)
                }
            })
        } else if sender == cancelBarButtonItem {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageVC")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    var footerViewBottomConstraint: Constraint? = nil
    var textViewHeightConstraint: Constraint? = nil
    var footerViewHeightConstraint: Constraint? = nil
    var profileImage = UIImage()

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
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
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
            tableView.isHidden = true
            print(myChat.count)
            if self.myChat.count > 3 {
                var lastIndex = IndexPath(row: self.myChat.count - 2, section: 0)
                self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
                tableView.isHidden = false
                lastIndex = IndexPath(row: self.myChat.count - 1, section: 0)
                self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
            }
            tableView.isHidden = false
        })
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
        let indexPath = IndexPath(row: count-1, section: 0)
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
            var chatType: ChatType
            if chat.chatRoomId == self.chatRoomId && chat.sender != JwtToken.shared.userId  {
                if chat.messageType == "Notice" {
                    chatType = chat
                    chatType.firstChat = false
                    self.isYourFirstChat = true
                } else if chat.sender == JwtToken.shared.userId {
                    chatType = chat
                    chatType.firstChat = false
                    self.isYourFirstChat = true
                } else {
                    if self.isYourFirstChat {
                        chatType = chat
                        chatType.firstChat = true
                        self.isYourFirstChat = false
                    } else {
                        chatType = chat
                        chatType.firstChat = false
                    }
                }
                self.myChat.append(chatType)
                self.updateChat(count: self.myChat.count) {
                    print("Get Message")
                }
                SocketIOManager.shared.readMessage(self.chatRoomId)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        chatRoomId = ""
        myChat = []
        chatTitle = ""
        removeKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        hideKeyboard()
        view.addSubview(lineViewFirst)
        view.addSubview(lineViewSecond)
        view.addSubview(tableView)
        view.addSubview(headerLabel)
        view.addSubview(footerView)
        footerView.addSubview(textView)
        footerView.addSubview(sendButton)
        lineViewFirst.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewFirst.snp.bottom).offset(1)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        lineViewSecond.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(3)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lineViewSecond.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(footerView.snp.top)
        }
        footerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(textView.snp.height).offset(10)
            footerViewBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        textView.snp.makeConstraints { make in
            make.centerY.equalTo(footerView)
            make.leading.equalTo(footerView).offset(10)
            make.trailing.equalTo(sendButton.snp.leading)
            textViewHeightConstraint = make.height.equalTo(40).constraint
        }
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(footerView)
            make.trailing.equalTo(footerView).offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        footerView.backgroundColor = .systemGray5
        tableView.allowsSelection = false
        textView.delegate = self
        navigationItem.rightBarButtonItems = [leaveBarButtonItem]
        bindMsg()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let photo = chatRootType == .project ? projectInfo.leader.photo : chatRoom.user.photo
        URLSession.shared.dataTask(with: NSURL(string: photo)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    if let image = UIImage(data: data) {
                        self.profileImage = image
                    }
                }
            }
        }).resume()
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.string(from: now)
        if chatRootType == .project {
            chatTitle = projectInfo.leader.nickName
            self.receiverId = projectInfo.leader.userId
            headerLabel.text = projectInfo.title
            navigationItem.title = projectInfo.leader.nickName
            MyAlamofireManager.shared.fetchRoomId(userId: self.receiverId, projectId: projectInfo.projectId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(roomId):
                    self.chatRoomId = roomId
                    MyAlamofireManager.shared.fetchChatMessageList(chatRoomId: self.chatRoomId) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case let .success(chatMessageList):
                            
                            self.makeOldBubbleChat(chatList: chatMessageList.chatList.oldChatList)
                            self.index = self.myChat.count
                            self.makeNewBubbleChat(chatList: chatMessageList.chatList.newChatList)
                            if self.myChat.count != 1 && self.myChat.last?.messageType != "Notice" && self.myChat.last?.sender != JwtToken.shared.userId && self.myChat.count != self.index && self.index != 1 {
                                    self.myChat.insert(ChatType(chatRoomId: self.chatRoomId, sender: "", receiver: self.receiverId, messageContent: "여기까지 읽으셨습니다.", messageType: "Notice", date: date), at: self.index)
                            }
                            SocketIOManager.shared.readMessage(self.chatRoomId)
                            self.scrollToMiddle()
                            
                        default:
                            break
                        }
                    }
                case .failure:
                    break
                }
            }
        } else {
            chatTitle = chatRoom.user.nickName
            self.chatRoomId = chatRoom.chatRoomId
            self.receiverId = chatRoom.user.userId
            headerLabel.text = chatRoom.projectTitle
            navigationItem.title = chatRoom.user.nickName
            MyAlamofireManager.shared.fetchChatMessageList(chatRoomId: chatRoomId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(chatMessageList):
                    
                    self.makeOldBubbleChat(chatList: chatMessageList.chatList.oldChatList)
                    self.index = self.myChat.count
                    self.makeNewBubbleChat(chatList: chatMessageList.chatList.newChatList)
                    if self.myChat.count != 1 && self.myChat.last?.messageType != "Notice" && self.myChat.last?.sender != JwtToken.shared.userId && self.myChat.count != self.index && self.index != 1 {
                            self.myChat.insert(ChatType(chatRoomId: self.chatRoomId, sender: "", receiver: self.receiverId, messageContent: "여기까지 읽으셨습니다.", messageType: "Notice", date: date, firstChat: false), at: self.index)
                    }
                    SocketIOManager.shared.readMessage(self.chatRoomId)
                    self.scrollToMiddle()
                default:
                    break
                }
            }
        }
        addKeyboardNotifications()
    }
    
    func scrollToMiddle() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            if self.myChat.count > 2 && self.index != 0 {
                let indexPath = IndexPath(row: self.index - 1, section: 0)
                print(self.index)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                self.tableView.reloadData()
            }
        }
    }
    func makeOldBubbleChat(chatList: [ChatLists.OldChatList]) {
        for chat in chatList {
            var chatType: ChatType
            if chat.messageType == "Notice" {
                chatType = ChatType(chatRoomId: self.chatRoomId, sender: chat.sender ?? "", receiver: self.receiverId, messageContent: chat.messageContent, messageType: chat.messageType, date: chat.date, firstChat: false)
                self.isYourFirstChat = true
            } else if chat.sender == JwtToken.shared.userId {
                chatType = ChatType(chatRoomId: self.chatRoomId, sender: chat.sender ?? "", receiver: self.receiverId, messageContent: chat.messageContent, messageType: chat.messageType, date: chat.date, firstChat: false)
                self.isYourFirstChat = true
            } else {
                if self.isYourFirstChat {
                    chatType = ChatType(chatRoomId: self.chatRoomId, sender: self.receiverId, receiver: JwtToken.shared.userId, messageContent: chat.messageContent, messageType: chat.messageType, date: chat.date, firstChat: true)
                    self.isYourFirstChat = false
                } else {
                    chatType = ChatType(chatRoomId: self.chatRoomId, sender: self.receiverId, receiver: JwtToken.shared.userId, messageContent: chat.messageContent, messageType: chat.messageType, date: chat.date, firstChat: false)
                }
            }
            self.myChat.append(chatType)
        }
    }
    
    func makeNewBubbleChat(chatList: [ChatLists.NewChatList]) {
        for chat in chatList {
            var chatType: ChatType
            if chat.messageType == "Notice" {
                chatType = ChatType(chatRoomId: self.chatRoomId, sender: chat.sender ?? "", receiver: self.receiverId, messageContent: chat.messageContent, messageType: chat.messageType, date: chat.date, firstChat: false)
                self.isYourFirstChat = true
            } else if chat.sender == JwtToken.shared.userId {
                chatType = ChatType(chatRoomId: self.chatRoomId, sender: chat.sender ?? "", receiver: self.receiverId, messageContent: chat.messageContent, messageType: chat.messageType, date: chat.date, firstChat: false)
                self.isYourFirstChat = true
            } else {
                if self.isYourFirstChat {
                    chatType = ChatType(chatRoomId: self.chatRoomId, sender: self.receiverId, receiver: JwtToken.shared.userId, messageContent: chat.messageContent, messageType: chat.messageType, date: chat.date, firstChat: true)
                    self.isYourFirstChat = false
                } else {
                    chatType = ChatType(chatRoomId: self.chatRoomId, sender: self.receiverId, receiver: JwtToken.shared.userId, messageContent: chat.messageContent, messageType: chat.messageType, date: chat.date, firstChat: false)
                }
            }
            self.myChat.append(chatType)
        }
    }
}

extension ChatRoomViewController: UITableViewDelegate {
    
}

extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellId = String()
        
        if self.myChat[indexPath.row].sender == JwtToken.shared.userId {
            cellId = "MyChatCell"
        } else if self.myChat[indexPath.row].messageType == "Notice" {
            cellId = "NoticeCell"
        } else if self.myChat[indexPath.row].firstChat {
            cellId = "YourProfileChatCell"
        } else {
            cellId = "YourChatCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let dateStr = self.myChat[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateStr)
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "HH:mm"
        let convertStr = myDateFormatter.string(from: date!)
        if cellId == "MyChatCell" {
            if let myChatCell = cell as? MyChatCell {
                myChatCell.chatLabel.text = self.myChat[indexPath.row].messageContent
                
                myChatCell.dateLabel.text = convertStr
            }
        } else if cellId == "NoticeCell" {
            if let noticeCell = cell as? NoticeCell {
                noticeCell.chatLabel.text = self.myChat[indexPath.row].messageContent
            }
        } else if let yourChatCell = cell as? YourChatCell {
            yourChatCell.chatLabel.text = self.myChat[indexPath.row].messageContent
            yourChatCell.dateLabel.text = convertStr

        } else if let yourProfileChatCell = cell as? YourProfileChatCell {
            yourProfileChatCell.chatLabel.text = self.myChat[indexPath.row].messageContent
            yourProfileChatCell.profileButton.setImage(self.profileImage, for: .normal)
            yourProfileChatCell.dateLabel.text = convertStr

        }

        print(cellId, indexPath)
        return cell
    }
}

extension ChatRoomViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.bounds.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        if estimatedSize.height <= 100 {
            self.textViewHeightConstraint?.update(offset: estimatedSize.height)
        }
        if textView.text.isEmpty {
            sendButton.setImage(UIImage(named: "send")?.withTintColor(ColorPortfolian.gray2, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            sendButton.setImage(UIImage(named: "send"), for: .normal)
        }
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

//맨 처음 시작 NewChatList에 "대화가 시작되었습니다."만 있고
//여기까지 읽으셨습니다 없어야됨
//
//그대로 다시 들어갔을 때 oldChatList에 "대화가 시작되었습니다."만 있고
//여기까지 읽으셨습니다 없어야됨
//
//다 읽고 나와서 그대로 다시 들어갔을 때 "여기까지 읽으셨습니다" 없어야됨
