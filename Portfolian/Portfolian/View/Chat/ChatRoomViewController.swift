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
    }
    
    var headerLabel = UILabel().then { UILabel in
        
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UILabel.textColor = .black
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
        UIBarButtonItem.tintColor = .black
    }
    
    var sendButton = UIButton().then { UIButton in
        UIButton.setImage(UIImage(named: "send"), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    var myChat: [ChatType] = []
        
    @objc func buttonPressed(_ sender: UIButton) {
        if sender == sendButton {
            if textView.text != "" {
                let chat = ChatType(roomId: chatRoomId, sender: JwtToken.shared.userId , receiver: receiverId, messageContent: textView.text)
                SocketIOManager.shared.sendMessage(chat)
                myChat.append(chat)
                print("\n\n\n@@@@\(myChat)@@@@\n\n\n")
                updateChat(count: myChat.count) {
                    print("채팅 송신")
                }
            }
        } else if sender == leaveBarButtonItem {
            MyAlamofireManager.shared.exitChatRoom(chatRoomId: chatRoomId, completion: { response in
                switch response {
                case .success():
                    print("방나가기 기능")
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

            if !self.myChat.isEmpty {
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
            if chat.roomId == self.chatRoomId && chat.sender != JwtToken.shared.userId  {
                self.myChat.append(chat)
                self.updateChat(count: self.myChat.count) {
                    print("Get Message") }
            }
        }
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
            make.top.equalTo(lineViewFirst.snp.bottom).offset(3)
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
        if chatRootType == .project {
            MyAlamofireManager.shared.fetchRoomId(userId: projectInfo.leader.userId , projectId: projectInfo.projectId) { response in
                switch response {
                case let .success(chatRoomId):
                    self.chatRoomId = chatRoomId
                case .failure:
                    print("실패")
                }
            }
            self.receiverId = projectInfo.leader.userId
            headerLabel.text = projectInfo.title
            navigationItem.title = projectInfo.leader.nickName
        } else {
            self.chatRoomId = chatRoom.chatRoomId
            self.receiverId = chatRoom.user.userId
            headerLabel.text = chatRoom.projectTitle
            navigationItem.title = chatRoom.user.nickName
        }
        
        
        addKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
//        let chat = ChatType(roomId: chatRoomId, sender: JwtToken.shared.userId, messageContent: "", date: Date.now)
//        SocketIOManager.shared.enterMessage(chat)
//        myChat.append(chat)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.tabBarController?.tabBar.isHidden = false
        removeKeyboardNotifications()

//        let chat = ChatType(roomId: chatRoomId, sender: JwtToken.shared.userId, messageContent: "", date: Date.now)
//        SocketIOManager.shared.leaveMessage(chat)
//        myChat.append(chat)
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
        if self.myChat[indexPath.row].sender == JwtToken.shared.userId  {
            cellId = "MyChatCell"
            isYourFirstChat = true
        } else if self.isYourFirstChat {
            cellId = "YourProfileChatCell"
            isYourFirstChat = false
        } else {
            cellId = "YourChatCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if cellId == "MyChatCell" {
            if let myChatCell = cell as? MyChatCell {
                myChatCell.chatLabel.text = self.myChat[indexPath.row].messageContent
            }
        } else {
            if let yourChatCell = cell as? YourChatCell {
                yourChatCell.chatLabel.text = self.myChat[indexPath.row].messageContent
            }
            if let yourProfileChatCell = cell as? YourProfileChatCell {
                yourProfileChatCell.chatLabel.text = self.myChat[indexPath.row].messageContent
                yourProfileChatCell.profileButton.setImage(profileImage, for: .normal)
            }
        }
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
