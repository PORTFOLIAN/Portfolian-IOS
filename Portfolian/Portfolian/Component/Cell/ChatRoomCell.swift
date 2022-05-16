//
//  ChatRoomCell.swift
//  Portfolian
//
//  Created by 이상현 on 2022/04/03.
//

import UIKit
import SnapKit
import Then

class ChatRoomCell: UITableViewCell {
    var containerView = UIView().then { _ in }

    var titleLabel = UILabel().then { UILabel in
        UILabel.text = "유저 닉네임"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    }
    
    var lastChatLabel = UILabel().then { UILabel in
        UILabel.text = "마지막 채팅"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        UILabel.textColor = .gray
    }
    
    var profileImageView = UIImageView().then { UIImageView in
        UIImageView.layer.cornerRadius = 30
        UIImageView.layer.borderWidth = 0.4
        UIImageView.layer.borderColor = ColorPortfolian.gray1.cgColor
        UIImageView.clipsToBounds = true
    }
    
    var dateLabel = UILabel().then { UILabel in
        UILabel.text = "00월 00일"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        UILabel.textColor = .gray
    }
    
    var projectLabel = UILabel().then { UILabel in
        UILabel.text = "React를 활용한 간단한 로그인 기능 구현하기"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 14)
        UILabel.numberOfLines = 2
        UILabel.textAlignment = .right
    }
    
    var numLabel = UILabel().then { UILabel in
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        UILabel.textColor = .white
        UILabel.backgroundColor = ColorPortfolian.thema
        UILabel.layer.cornerRadius = 5
        UILabel.layer.borderColor = UIColor.clear.cgColor
        UILabel.clipsToBounds = true
        UILabel.textAlignment = .center
        UILabel.sizeToFit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setup() {
        self.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(lastChatLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(profileImageView)
        containerView.addSubview(projectLabel)
        containerView.addSubview(numLabel)

        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(16)
            make.top.equalTo(self)
            make.bottom.equalTo(self).offset(-8)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(containerView).offset(10)
            make.width.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.snp.centerX).offset(10)
            make.bottom.equalTo(profileImageView.snp.centerY)
        }
        
        lastChatLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.top.equalTo(profileImageView.snp.centerY)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(containerView).inset(10)
        }
        
        projectLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.snp.centerX).offset(20)
            make.trailing.equalTo(dateLabel)
            make.bottom.lessThanOrEqualTo(self).offset(5)
        }
        
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-10)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}




