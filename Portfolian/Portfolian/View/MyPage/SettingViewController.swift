//
//  SettingViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/22.
//

import UIKit
import Then
import SnapKit
import Toast_Swift
import KakaoSDKAuth
import KakaoSDKUser
import CoreData

class SettingViewController: UIViewController {
    lazy var cancelBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(buttonPressed(_:)))
    
    lazy var tableView = UITableView().then { make in
        make.register(BasicTableViewCell.self, forCellReuseIdentifier: "BasicTableViewCell")
    }
    
    let settingMenu = [
        "버전",
        "로그아웃",
        "회원 탈퇴"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
//        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "설정"

        self.navigationItem.largeTitleDisplayMode = .always

        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.row) {
        case 0:
            print("화면이동 2")
            let version = "1.0.0"
            view.makeToast("현재 버전은 \(version)입니다.😶‍🌫️", duration: 1.0, position: .center)
            
        case 1:
            logoutKakao()
        default:
            unlinkKakao()
        }
    }
    func logoutKakao() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                MyAlamofireManager.shared.patchLogout { result in
                    print("logout() success.")
                }
                let requestWriting: NSFetchRequest<Writing> = Writing.fetchRequest()
                let request = PersistenceManager.shared.fetch(request: requestWriting)
                if !request.isEmpty {
                    PersistenceManager.shared.deleteAll(request: requestWriting)
                }
                KeychainManager.shared.delete(key: "refreshToken")
                KeychainManager.shared.delete(key: "accessToken")
                KeychainManager.shared.delete(key: "userId")
                writingTeamTag.names = []
                writingOwnerTag.names = []
                JwtToken.shared = JwtToken()
                SocketIOManager.shared.closeConnection()
                self.goToApp()
            }
        }
    }
    func unlinkKakao() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
                let requestWriting: NSFetchRequest<Writing> = Writing.fetchRequest()
                let request = PersistenceManager.shared.fetch(request: requestWriting)
                if !request.isEmpty {
                    PersistenceManager.shared.deleteAll(request: requestWriting)
                }
                writingTeamTag.names = []
                writingOwnerTag.names = []
                MyAlamofireManager.shared.deleteUserId { result in
                    KeychainManager.shared.delete(key: "refreshToken")
                    KeychainManager.shared.delete(key: "accessToken")
                    KeychainManager.shared.delete(key: "userId")
                    JwtToken.shared = JwtToken()
                }
                SocketIOManager.shared.closeConnection()
                self.goToApp()
            }
        }
    }
    func goToApp() {
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
        
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SigninVC")
        vc.modalPresentationStyle = .fullScreen
        self.tabBarController?.present(vc, animated: true, completion: nil)
    }
    @objc func buttonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTableViewCell", for: indexPath)
        cell.textLabel?.text = settingMenu[indexPath.row]
        
        return cell
        
    }
    
    // 셀의 크기 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0;//Choose your custom row height
    }
    
}
