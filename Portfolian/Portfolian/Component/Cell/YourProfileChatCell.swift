//
//  YourChatCell.swift
//  Portfolian
//
//  Created by 이상현 on 2022/04/03.
//

import UIKit
import Then
import SnapKit

class YourProfileChatCell: UITableViewCell {
    var profileButton = UIButton().then { UIButton in
        UIButton.layer.cornerRadius = 20
        UIButton.layer.borderWidth = 0.4
        UIButton.layer.borderColor = ColorPortfolian.gray1.cgColor
        UIButton.clipsToBounds = true
        UIButton.contentMode = .scaleAspectFill
        let vc = ChatRoomViewController()
        UIButton.addTarget(vc, action: #selector(vc.buttonPressed(_:)), for: .touchUpInside)
    }
    
    var chatLabel = PaddingLabel().then { PaddingLabel in
        PaddingLabel.textColor = ColorPortfolian.baseBlack
        PaddingLabel.backgroundColor = ColorPortfolian.more
        PaddingLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    var dateLabel = UILabel().then { UILabel in
        UILabel.textColor = ColorPortfolian.gray2
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 12)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(profileButton)
        self.addSubview(chatLabel)
        self.addSubview(dateLabel)

        profileButton.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(10)
            make.top.equalTo(self)
            make.width.height.equalTo(40)
            
        }
        chatLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileButton.snp.trailing).offset(10)
            make.top.equalTo(profileButton).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.width.lessThanOrEqualTo(300)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(chatLabel).offset(-5)
            make.leading.equalTo(chatLabel.snp.trailing).offset(5)
        }
        contentView.isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
