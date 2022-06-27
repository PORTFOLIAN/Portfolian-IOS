//
//  SigninViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/17.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import SwiftyJSON
import AuthenticationServices
import Toast_Swift
import CoreData

class SigninViewController: UIViewController {
    let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logo"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let introduceLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 첫 프로젝트\n포트폴리안에서 시작해보세요!"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakaoLogin"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let noLoginButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        button.setTitle("로그인없이 시작하기", for: .normal)
        button.setUnderline()
        button.setTitleColor(ColorPortfolian.gray1, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(introduceLabel)
        containerView.addSubview(noLoginButton)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(kakaoLoginButton)
        stackView.addArrangedSubview(appleLoginButton)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            introduceLabel.bottomAnchor.constraint(equalTo: logoImageView.topAnchor, constant: -75),
            introduceLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            logoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -100),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            noLoginButton.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 50),
            noLoginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            noLoginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: noLoginButton.bottomAnchor, constant: 50),
            stackView.centerXAnchor.constraint(equalTo: noLoginButton.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            stackView.heightAnchor.constraint(equalToConstant: 100),
        ])
        // Do any additional setup after loading the view.
        kakaoLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
        noLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
    }
    
    //MARK: - ButtonHandler
    @objc func LoginButtonHandler(_ sender: UIButton) {
        //do something
        switch sender {
        case kakaoLoginButton:
            // 카카오톡으로 로그인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                loginAppKakao()
            } else {
                loginWebKakao()
            }
        case noLoginButton:
            UserDefaults.standard.set(LoginType.no.rawValue, forKey: "loginType")
            loginType = LoginType(rawValue: UserDefaults.standard.integer(forKey: "loginType"))
            self.goHome()
        case appleLoginButton:
            let request = ASAuthorizationAppleIDProvider().createRequest()
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self as ASAuthorizationControllerDelegate
            authorizationController.presentationContextProvider = self as ASAuthorizationControllerPresentationContextProviding
            authorizationController.performRequests()
        default:
            break
            
        }
    }
    
    // 카카오톡 앱으로 로그인하기
    func loginAppKakao() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if error == nil {
                guard let accessToken = oauthToken?.accessToken else { return }
                MyAlamofireManager.shared.postKaKaoToken(token: accessToken) {
                    guard let refreshToken = KeychainManager.shared.read(key: "refreshToken") else { return }
                    JwtToken.shared.accessToken = Jwt.shared.accessToken
                    JwtToken.shared.refreshToken = refreshToken
                    JwtToken.shared.userId = Jwt.shared.userId
                    SocketIOManager.shared.establishConnection()
                    SocketIOManager.shared.connectCheck { [weak self] Bool in
                        guard let self = self else { return }
                        if Bool {
                            if Jwt.shared.isNew == true {
                                self.setNickName()
                            } else {
                                self.goHome()
                            }
                        } else {
                            self.logoutKakao()
                        }
                    }
                }
            } else {
                self.view.makeToast("다시 시도해주세요 :)", duration: 0.75, position: .center)
            }
        }
    }
    
    // 카카오톡 웹으로 로그인하기
    func loginWebKakao() {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            if error == nil {
                print("loginWithKakaoAccount() success.")
                guard let accessToken = oauthToken?.accessToken else { return }
                MyAlamofireManager.shared.postKaKaoToken(token: accessToken) {
                    guard let refreshToken = KeychainManager.shared.read(key: "refreshToken") else { return }
                    JwtToken.shared.accessToken = Jwt.shared.accessToken
                    JwtToken.shared.refreshToken = refreshToken
                    JwtToken.shared.userId = Jwt.shared.userId
                    SocketIOManager.shared.establishConnection()
                    SocketIOManager.shared.connectCheck { [weak self] Bool in
                        guard let self = self else { return }
                        if Bool {
                            if Jwt.shared.isNew == true {
                                self.setNickName()
                            } else {
                                self.goHome()
                            }
                        } else {
                            self.logoutKakao()
                        }
                    }
                }
            } else {
                self.view.makeToast("다시 시도해주세요 :)", duration: 0.75, position: .center)
            }
        }
    }
    
    private func goHome() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.goHome()
        }
    }
    
    // 닉네임설정화면으로 전환
    private func setNickName() {
        let nicknameVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "NicknameVC")
        nicknameVC.modalPresentationStyle = .fullScreen
        self.present(nicknameVC, animated: true)
    }
    
    private func logoutKakao() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                MyAlamofireManager.shared.patchFcm(fcm: "") {
                    MyAlamofireManager.shared.patchLogout { [weak self] in
                        guard let self = self else { return }
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
                        self.view.makeToast("일시적인 오류입니다. 다시 시도해주세요 :)", duration: 0.75, position: .center)
                    }
                }
            }
        }
    }
    
    private func logoutApple() {
        MyAlamofireManager.shared.patchFcm(fcm: "") {
            MyAlamofireManager.shared.patchLogout { [weak self] in
                guard let self = self else { return }
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
                self.view.makeToast("일시적인 오류입니다. 다시 시도해주세요 :)", duration: 0.75, position: .center)
            }
        }
    }
}

extension SigninViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // 로그인 진행하는 화면 표출
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            MyAlamofireManager.shared.postAppleToken(userId: userIdentifier) {
                guard let refreshToken = KeychainManager.shared.read(key: "refreshToken") else { return }
                JwtToken.shared.accessToken = Jwt.shared.accessToken
                JwtToken.shared.refreshToken = refreshToken
                JwtToken.shared.userId = Jwt.shared.userId
                SocketIOManager.shared.establishConnection()
                SocketIOManager.shared.connectCheck { [weak self] Bool in
                    guard let self = self else { return }
                    if Bool {
                        if Jwt.shared.isNew == true {
                            self.setNickName()
                        } else {
                            self.goHome()
                        }
                    } else {
                        self.logoutApple()
                    }
                }
            }
        default:
            break
        }
    }
}

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
