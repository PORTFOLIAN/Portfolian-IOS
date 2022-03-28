//
//  ChatBalloonCell.swift
//  Portfolian
//
//  Created by 이상현 on 2022/03/22.
//

import UIKit
import Then
import SnapKit

class MyChatCell: UITableViewCell {
    var chatLabel = PaddingLabel().then { PaddingLabel in
        PaddingLabel.backgroundColor = ColorPortfolian.thema
        PaddingLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(chatLabel)
        chatLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.bottom.trailing.equalTo(self).offset(-10)
            make.width.lessThanOrEqualTo(300)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

