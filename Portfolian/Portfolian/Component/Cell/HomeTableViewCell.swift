//
//  HomeTableViewCell.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/24.
//

import UIKit
protocol BookmarkButtonDelegate: AnyObject {
    func didTouchBookmarkButton(didClicked: Bool)
    
}
class HomeTableViewCell: UITableViewCell {
    // CustomCell.swift
    var cnt = 0
    var cellDelegate: BookmarkButtonDelegate?
    var isClicked = false
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Bookmark2"), for: .normal)
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ProfileImage")
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
    
    lazy var IllustratorButton: TagButton = {
        lazy var button = TagButton()
        button.informTextInfo(text: "Illustrator", fontSize: 14)
        button.currentColor(color: ColorPortfolian.illustrator)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var iosButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Front-end", fontSize: 14)
        button.currentColor(color: ColorPortfolian.frontEnd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var typescriptButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Typescript", fontSize: 14)
        button.currentColor(color: ColorPortfolian.typescript)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var NumberOftagsLabel: UILabel = {
        let label = UILabel()
        label.text = "+ 4"
        label.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 컨텐츠뷰 클릭을 가능하게 만들어주기.
        setUserInteraction()
        addTarget()
        setup()
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
    
    func setup() {

        self.addSubview(containerView)
        containerView.addSubview(bookmarkButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(viewsLabel)
        containerView.addSubview(profileImageView)
        containerView.addSubview(tagStackView)
        tagStackView.addArrangedSubview(IllustratorButton)
        tagStackView.addArrangedSubview(iosButton)
        tagStackView.addArrangedSubview(typescriptButton)
        containerView.addSubview(NumberOftagsLabel)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),

            bookmarkButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            bookmarkButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 20),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -10),
//            titleLabel.bottomAnchor.constraint(equalTo: tagView.topAnchor, constant: 20),

            profileImageView.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),

            viewsLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            viewsLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),

            tagStackView.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 5),
            tagStackView.leadingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor),
            tagStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            NumberOftagsLabel.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 5),
            NumberOftagsLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            NumberOftagsLabel.centerYAnchor.constraint(equalTo: tagStackView.centerYAnchor)
        ])
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        cellDelegate?.didTouchBookmarkButton(didClicked: isClicked)
        isClicked.toggle()
        if isClicked == true{
            sender.setImage(UIImage(named: "BookmarkFill"), for: .normal)
        }else{
            sender.setImage(UIImage(named: "Bookmark2"), for: .normal)
            }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
}
