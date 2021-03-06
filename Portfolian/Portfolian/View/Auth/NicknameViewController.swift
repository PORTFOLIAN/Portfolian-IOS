//
//  nicknameViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/17.
//

import UIKit

class NicknameViewController: UIViewController, UITextFieldDelegate {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let requestNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "반가워요!\n닉네임을 설정해주세요. (10자 이내)"
        label.font = UIFont(name: "NotoSansKR-Bold", size: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "next")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = ColorPortfolian.more
        return button
    }()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        containerView.addSubview(requestNicknameLabel)
        containerView.addSubview(nicknameTextField)
        containerView.addSubview(nextButton)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            requestNicknameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 80),
            requestNicknameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            requestNicknameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            requestNicknameLabel.heightAnchor.constraint(equalToConstant: 60),
            nicknameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 100),
            nicknameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -100),
            nicknameTextField.topAnchor.constraint(equalTo: containerView.centerYAnchor),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 40),
            nextButton.centerYAnchor.constraint(equalTo: nicknameTextField.centerYAnchor),
            nextButton.leftAnchor.constraint(equalTo: nicknameTextField.rightAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        // Do any additional setup after loading the view.
        nicknameTextField.delegate = self
        nextButton.addTarget(self, action: #selector(ButtonHandler(_:)), for: .touchUpInside)
        nicknameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        nicknameTextField.resignFirstResponder()
    }
    
    //MARK: - Buttonhandler
    @objc func ButtonHandler(_ sender: UIButton) {
        if checkNickname(nicknameTextField) == true {
            MyAlamofireManager.shared.patchNickName(nickName: nicknameTextField.text!) {
                self.goToHome()
            }
        }
        
    }
    
    //MARK: Change Button TintColor
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let nicknameText = textField.text else { return }
        nextButton.tintColor = nicknameText.isEmpty ? ColorPortfolian.more : ColorPortfolian.thema
        if nicknameText.count >= 10 {
            limitNicknameTenLetters(textField, nickname: nicknameText)
        }
    }
    
    //MARK: - Limit 10 letters
    private func limitNicknameTenLetters(_ textField: UITextField, nickname: String) {
        let nicknameCharacterLimit = 10
        let endIndex: String.Index = nickname.index(nickname.startIndex, offsetBy: nicknameCharacterLimit)
        textField.text = String(nickname[..<endIndex])
        
    }
    
    //MARK: - NickName Check
    private func checkNickname(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            return false
        } else {
            return true
        }
    }
    
    private func goToHome() {
      if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
        sceneDelegate.goHome()
      }
    }
    
    //MARK: Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
