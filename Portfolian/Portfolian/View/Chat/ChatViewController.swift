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
    var tableView = UITableView().then { UITableView in
        UITableView.register(ChatRoomCell.self, forCellReuseIdentifier: "ChatRoomCell")
    }
    
    let titleLabel = UILabel().then { UILabel in
        UILabel.text = "채팅"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 20)
        UILabel.textAlignment = .left
    }
        
    var chatType = ChatType()
    
    var chatRoomList = ChatRoomList()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        MyAlamofireManager.shared.fetchChatRoomList { result in
            switch result{
            case let .success(chatRoomList):
                self.chatRoomList = chatRoomList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.setNeedsLayout()
                }
            default:
                print("오류")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        // Do any additional setup after loading the view.
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    // 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomList.chatRoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as! ChatRoomCell
        let chatRoomInfo = chatRoomList.chatRoomList[indexPath[1]]
        
        let dateStr = chatRoomInfo.newChatDate // Date 형태의 String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateStr)
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM월 dd일" // 2020년 08월 13일 오후 04시 30분
        let convertStr = myDateFormatter.string(from: date!)
        cell.dateLabel.text = convertStr
        
        cell.lastChatLabel.text = chatRoomInfo.newChatContent
        cell.projectLabel.text = chatRoomInfo.projectTitle
        cell.titleLabel.text = chatRoomInfo.user.nickName
        URLSession.shared.dataTask( with: NSURL(string: chatRoomInfo.user.photo)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async { [weak self] in
                if let data = data {
                    let image = UIImage(data: data)
                    cell.profileImageView.image = image
                }
            }
        }).resume()
        return cell
    }
    
    // 셀이 선택 되었을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("채팅방으로 넘어가기")
        chatRootType = .chatRoom
        profileType = .yourProfile
        chatRoom = chatRoomList.chatRoomList[indexPath[1]]
        print(chatRoom)
        let chatRoomVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatRoomVC")
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
    }
    
    
    // 셀의 크기 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}
