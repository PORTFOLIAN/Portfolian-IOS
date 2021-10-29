//
//  WritingViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/29.
//

import UIKit

class WritingViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .blue
        return view
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var saveBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(buttonPressed))
        return button
    }()

    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목을 입력하세요."
        textField.font = UIFont(name: "NotoSansKR-Bold", size: 18)

        return textField
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorPortfolian.gray2
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "글쓰기"
        navigationItem.rightBarButtonItem = saveBarButtonItem
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(lineView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            lineView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5),
            lineView.leadingAnchor.constraint(equalTo: titleTextField.leftAnchor),
            lineView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            
        ])
        contentView.backgroundColor = .blue
    }

    // MARK: - Navigation
    @objc private func buttonPressed(_ sender: UIButton) {
    }


}





