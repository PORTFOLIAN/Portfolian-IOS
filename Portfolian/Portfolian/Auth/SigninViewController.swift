//
//  SigninViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/17.
//

import UIKit

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
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let googleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let githubLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
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
            kakaoLoginButton.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 50),
            kakaoLoginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            kakaoLoginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 50),
            googleLoginButton.topAnchor.constraint(equalTo: kakaoLoginButton.bottomAnchor, constant: 10),
            googleLoginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            googleLoginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            githubLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 10),
            githubLoginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            githubLoginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            githubLoginButton.heightAnchor.constraint(equalToConstant: 50),
            appleLoginButton.topAnchor.constraint(equalTo: githubLoginButton.bottomAnchor, constant: 10),
            appleLoginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            appleLoginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        // Do any additional setup after loading the view.
        kakaoLoginButton.addTarget(self, action: #selector(LoginButtonHandler(_:)), for: .touchUpInside)
        swipeRecognizer()

    }
    
    //MARK: - ButtonHandler
    @objc func LoginButtonHandler(_ sender: UIButton) {
        let nicknameVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "NicknameVC")
        nicknameVC.modalPresentationStyle = .fullScreen
        present(nicknameVC, animated: true)
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
