//
//  SigninViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/17.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
class SigninViewController: UIViewController {
    let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "Logo"))
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
        label.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let githubLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signInConfig = GIDConfiguration(clientID: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(introduceLabel)
        containerView.addSubview(kakaoLoginButton)
        containerView.addSubview(googleLoginButton)
        containerView.addSubview(githubLoginButton)
        containerView.addSubview(appleLoginButton)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            logoImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            logoImageView.rightAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            introduceLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 90),
            introduceLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            introduceLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 20),
            
            googleLoginButton.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 50),
            googleLoginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            googleLoginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            kakaoLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 10),
            kakaoLoginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 3),
            kakaoLoginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 45),
            githubLoginButton.topAnchor.constraint(equalTo: kakaoLoginButton.bottomAnchor, constant: 10),
            githubLoginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 3),
            githubLoginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -3),
            githubLoginButton.heightAnchor.constraint(equalToConstant: 45),
            appleLoginButton.topAnchor.constraint(equalTo: githubLoginButton.bottomAnchor, constant: 10),
            appleLoginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 3),
            appleLoginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -3),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 45),
        ])
        // Do any additional setup after loading the view.
        kakaoLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
        swipeRecognizer()
        
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
        case googleLoginButton:
            // 구글 로그인

            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [self] user, error in
                print(1)
                guard error == nil else { return }
                // If sign in succeeded, display the app's main content View.
                self.fetchGoogleIDToken()
                self.setNickName()
            }
        case githubLoginButton:
            // 구글 로그아웃
              GIDSignIn.sharedInstance.signOut()
        
        case appleLoginButton:
            UserApi.shared.unlink {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("unlink() success.")
                }
            }
        default:
            logoutKakao()
        }
    }
    
    func fetchGoogleIDToken() {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }

            user.authentication.do { authentication, error in
                guard error == nil else { return }
                guard let authentication = authentication else { return }

                let idToken = authentication.idToken! as String
                // Send ID token to backend (example below).
                self.postGoogleIDToken(idToken: idToken)
            }
        }
    }
    
    func postGoogleIDToken(idToken: String) {
        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
            return
        }
        let url = URL(string: "http://3.36.84.11:3000/auth/google/callback")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // Handle response from your backend.
        }
        task.resume()
    }
    
    func logoutKakao() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
    
    // 닉네임설정화면으로 전환
    func setNickName() {
        let nicknameVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "NicknameVC")
        nicknameVC.modalPresentationStyle = .fullScreen
        self.present(nicknameVC, animated: true)
    }
    
    // 카카오톡 앱으로 로그인하기
    func loginAppKakao() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                self.setNickName()
                _ = oauthToken
                
            }
        }
    }
    
    // 카카오톡 웹으로 로그인하기
    func loginWebKakao() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                self.setNickName()
                _ = oauthToken
            }
        }
    }
    
    //MARK: - SwipeGesture
    func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                // 스와이프 시, 뒤로가기
                if User.shared.flag == true {
                    self.dismiss(animated: true, completion: nil)
                }
            default: break
            }
        }
        
    }
    
}


