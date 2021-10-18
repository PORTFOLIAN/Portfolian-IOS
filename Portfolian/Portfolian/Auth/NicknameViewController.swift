//
//  nicknameViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/17.
//

import UIKit

class nicknameViewController: UIViewController, UITextFieldDelegate {
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
        button.tintColor = .blue
        button.setImage(UIImage(named: "nextButton"), for: .normal)
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
        swipeRecognizer()
    }
    
    //MARK: - Buttonhandler
    @objc func ButtonHandler(_ sender: UIButton) {
//        mainVC.modalPresentationStyle = .fullScreen
        User.shared.flag = true
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        
        }
    
    //MARK: - swipeGesture
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
                self.dismiss(animated: true, completion: nil)
            default: break
            }
        }
    }
    
    //MARK: Change buttonImage
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty != true {
            nextButton.setImage(UIImage(named: "nextButtonHighlighted"), for: .normal)
        } else {
            nextButton.setImage(UIImage(named: "nextButton"), for: .normal)
        }
    }
    
    //MARK: Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

