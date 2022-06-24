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
import MessageUI

class SettingViewController: UIViewController {
    lazy var cancelBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(buttonPressed(_:)))
    
    lazy var tableView = UITableView().then { make in
        make.register(BasicTableViewCell.self, forCellReuseIdentifier: "BasicTableViewCell")
    }
    
    let settingMenu = [
        "버전",
        "개인정보 처리방침",
        "문의하기",
        "로그아웃",
        "회원 탈퇴"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        self.navigationItem.title = "설정"

        self.navigationItem.largeTitleDisplayMode = .always

        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func checkEmailAvailability() -> Bool {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return false
        }
        return true
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.row) {
        case 0:
            let version = "1.0.1"
            view.makeToast("현재 버전은 \(version)입니다.😶‍🌫️", duration: 1.0, position: .center)
        case 1:
            let safariViewController = WebViewController()
            safariViewController.url = URL(string: "https://yi-sang.github.io/privacy")
            present(safariViewController, animated: true, completion: nil)
        case 2:
            if checkEmailAvailability()
            {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setToRecipients(["sanghyle@icloud.com"])
                composeVC.setSubject("문의하기")
                composeVC.setMessageBody("\(UIDevice.current.localizedModel)\n\(UIDevice.current.systemVersion)\n\(UIDevice.current.orientation)\n- 문의내용:", isHTML: false)
                                  
                self.present(composeVC, animated: true, completion: nil)
            } else {
                showSendMailErrorAlert()
            }
            
        case 3:
            UserDefaults.standard.set(LoginType.no.rawValue, forKey: "loginType")
            switch loginType {
            case .kakao:
                loginType = LoginType(rawValue: UserDefaults.standard.integer(forKey: "loginType"))
                logoutKakao()
            case .apple:
                loginType = LoginType(rawValue: UserDefaults.standard.integer(forKey: "loginType"))
                logoutApple()
            default:
                break
            }
        default:
            UserDefaults.standard.set(LoginType.no.rawValue, forKey: "loginType")
            switch loginType {
            case .apple:
                loginType = LoginType(rawValue: UserDefaults.standard.integer(forKey: "loginType"))
                unlinkApple()
            case .kakao:
                loginType = LoginType(rawValue: UserDefaults.standard.integer(forKey: "loginType"))
                unlinkKakao()
            default:
                break
            }
        }
    }
    func logoutKakao() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                MyAlamofireManager.shared.patchFcm(fcm: "") {
                    MyAlamofireManager.shared.patchLogout {
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
                        KeychainManager.shared.create(key: "fcmToken", token: "")
                        SocketIOManager.shared.closeConnection()
                        self.goToApp()
                    }
                }
            }
        }
    }
    
    func logoutApple() {
        MyAlamofireManager.shared.patchFcm(fcm: "") {
            MyAlamofireManager.shared.patchLogout {
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
                MyAlamofireManager.shared.patchFcm(fcm: "") {
                    let requestWriting: NSFetchRequest<Writing> = Writing.fetchRequest()
                    let request = PersistenceManager.shared.fetch(request: requestWriting)
                    if !request.isEmpty {
                        PersistenceManager.shared.deleteAll(request: requestWriting)
                    }
                    writingTeamTag.names = []
                    writingOwnerTag.names = []
                    MyAlamofireManager.shared.deleteUserId {
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
    }
    
    func unlinkApple() {
        MyAlamofireManager.shared.patchFcm(fcm: "") {
            let requestWriting: NSFetchRequest<Writing> = Writing.fetchRequest()
            let request = PersistenceManager.shared.fetch(request: requestWriting)
            if !request.isEmpty {
                PersistenceManager.shared.deleteAll(request: requestWriting)
            }
            writingTeamTag.names = []
            writingOwnerTag.names = []
            MyAlamofireManager.shared.deleteUserId {
                KeychainManager.shared.delete(key: "refreshToken")
                KeychainManager.shared.delete(key: "accessToken")
                KeychainManager.shared.delete(key: "userId")
                JwtToken.shared = JwtToken()
            }
            SocketIOManager.shared.closeConnection()
            MyAlamofireManager.shared.patchFcm(fcm: "") {
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
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
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

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
}
