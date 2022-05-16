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
        button.imageView?.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let noLoginButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        button.setTitle("로그인 없이 시작하기", for: .normal)
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(introduceLabel)
        containerView.addSubview(kakaoLoginButton)
        containerView.addSubview(noLoginButton)
        containerView.addSubview(appleLoginButton)
        
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
            kakaoLoginButton.topAnchor.constraint(equalTo: noLoginButton.bottomAnchor, constant: 50),
            kakaoLoginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 3),
            kakaoLoginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 45),
            appleLoginButton.topAnchor.constraint(equalTo: kakaoLoginButton.bottomAnchor, constant: 10),
            appleLoginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 3),
            appleLoginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -3),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 45),
        ])
        // Do any additional setup after loading the view.
        kakaoLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
        noLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
//        swipeRecognizer()
        
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
//            request.requestedScopes = [.fullName, .email]
            
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
            if let error = error {
                print(error)
                print("카카오톡과 통신에 실패했습니다.\n재시도 부탁드립니다😶‍🌫️ ")
                self.view.makeToast("카카오톡과 통신에 실패했습니다.\n재시도 부탁드립니다😶‍🌫️ ", duration: 1.5, position: .center)
            }
            else {
                print("loginWithKakaoAccount() success.")
                guard let accessToken = oauthToken?.accessToken else { return }
                print("#####\(accessToken)")
                MyAlamofireManager.shared.postKaKaoToken(token: accessToken, completion: { result in
                    switch result {
                    case .success():
                        guard let refreshToken = KeychainManager.shared.read(key: "refreshToken") else { return }
                        JwtToken.shared.accessToken = Jwt.shared.accessToken
                        JwtToken.shared.refreshToken = refreshToken
                        JwtToken.shared.userId = Jwt.shared.userId
                        if Jwt.shared.isNew == true {
                            self.setNickName()
                        } else {
                            self.goHome()
                        }
                        
                    case .failure:
                        print("error")
                    }
                })
            }
        }
    }
    
    // 카카오톡 웹으로 로그인하기
    func loginWebKakao() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
                self.view.makeToast("카카오톡과 통신에 실패했습니다. 재시도 부탁드립니다 :)", duration: 1.0, position: .center)

            }
            else {
                print("loginWithKakaoAccount() success.")
                guard let accessToken = oauthToken?.accessToken else { return }
                MyAlamofireManager.shared.postKaKaoToken(token: accessToken, completion: { result in
                    switch result {
                    case .success():
                        guard let refreshToken = KeychainManager.shared.read(key: "refreshToken") else { return }
                        JwtToken.shared.accessToken = Jwt.shared.accessToken
                        JwtToken.shared.refreshToken = refreshToken
                        JwtToken.shared.userId = Jwt.shared.userId
                        if Jwt.shared.isNew == true {
                            self.setNickName()
                        } else {
                            self.goHome()
                        }
                        
                    case .failure:
                        print("error")
                    }
                })
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
    //MARK: - SwipeGesture
//    func swipeRecognizer() {
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        self.view.addGestureRecognizer(swipeRight)
//
//    }
//
//    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            switch swipeGesture.direction{
//            case UISwipeGestureRecognizer.Direction.right:
//                // 스와이프 시, 뒤로가기
//                self.dismiss(animated: true, completion: nil)
//
//            default: break
//            }
//        }
//    }
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
                MyAlamofireManager.shared.postAppleToken(userId: userIdentifier) { result in
                    switch result {
                    case .success():
                        guard let refreshToken = KeychainManager.shared.read(key: "refreshToken") else { return }
                        JwtToken.shared.accessToken = Jwt.shared.accessToken
                        JwtToken.shared.refreshToken = refreshToken
                        JwtToken.shared.userId = Jwt.shared.userId
                        if Jwt.shared.isNew == true {
                            self.setNickName()
                        } else {
                            self.goHome()
                        }
                        
                    case .failure:
                        print("error")
                    }
                }
            default:
                break
            }
        }
        
        // Apple ID 연동 실패 시
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            // Handle error.
            print(error)
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
