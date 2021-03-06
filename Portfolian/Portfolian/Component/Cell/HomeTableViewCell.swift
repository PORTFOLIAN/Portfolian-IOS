//
//  HomeTableViewCell.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/24.
//

import UIKit

protocol BookmarkButtonDelegate: AnyObject {
    func didTouchBookmarkButton(didClicked: Bool, sender: UIButton)
    
}
class HomeTableViewCell: UITableViewCell {
    var cellDelegate: BookmarkButtonDelegate?
    var isClicked = false
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorPortfolian.noclickTag.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Bookmark"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "React를 활용한 간단한 로그인 기능 구현하기"
        label.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "조회 777"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0.4
        imageView.layer.borderColor = ColorPortfolian.gray2.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var tagStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tagButton1: TagButton = {
        lazy var button = TagButton()
        button.informTextInfo(text: "Illustrator", fontSize: 10)
        button.currentColor(color: ColorPortfolian.illustrator)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tagButton2: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Front-end", fontSize: 12)
        button.currentColor(color: ColorPortfolian.frontEnd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tagButton3: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Typescript", fontSize: 12)
        button.currentColor(color: ColorPortfolian.typescript)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var numberOftagsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 컨텐츠뷰 클릭을 가능하게 만들어주기.
        setUserInteraction()
        addTarget()
        setupSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }

    func addTarget() {
        bookmarkButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    func setUserInteraction() {
        contentView.isUserInteractionEnabled = true
        tagStackView.isUserInteractionEnabled = false
    }
    
    private func setupSubview() {
        self.addSubview(containerView)
        containerView.addSubview(bookmarkButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(viewsLabel)
        containerView.addSubview(profileImageView)
        containerView.addSubview(tagStackView)
        tagStackView.addArrangedSubview(tagButton1)
        tagStackView.addArrangedSubview(tagButton2)
        tagStackView.addArrangedSubview(tagButton3)
        containerView.addSubview(numberOftagsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),

            bookmarkButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -5),
            bookmarkButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -10),

            profileImageView.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: -5),
            profileImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),

            viewsLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            viewsLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),

            tagStackView.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 5),
            tagStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant:  25),
            tagStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            numberOftagsLabel.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 5),
            numberOftagsLabel.leadingAnchor.constraint(equalTo: tagStackView.trailingAnchor, constant: 10),
            numberOftagsLabel.centerYAnchor.constraint(equalTo: tagStackView.centerYAnchor)
        ])
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        cellDelegate?.didTouchBookmarkButton(didClicked: isClicked,sender: sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}



