//
//  NoticeCell.swift
//  Portfolian
//
//  Created by 이상현 on 2022/05/08.
//

import UIKit
import Then
import SnapKit

class NoticeCell: UITableViewCell {
    var chatLabel = PaddingLabel().then { PaddingLabel in
        PaddingLabel.textColor = ColorPortfolian.thema
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(chatLabel)

        chatLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(self)
            make.height.equalTo(self)
            make.centerX.equalTo(self)
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
