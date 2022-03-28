//
//  YourChatCell.swift
//  Portfolian
//
//  Created by 이상현 on 2022/03/23.
//

import UIKit
import Then
import SnapKit

class YourChatCell: UITableViewCell {
    var chatLabel = PaddingLabel().then { PaddingLabel in
        PaddingLabel.backgroundColor = ColorPortfolian.more
        PaddingLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(chatLabel)

        chatLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
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
