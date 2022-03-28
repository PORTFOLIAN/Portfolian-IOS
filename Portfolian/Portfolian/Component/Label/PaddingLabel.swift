//
//  PaddingLabel.swift
//  Portfolian
//
//  Created by 이상현 on 2022/03/22.
//

import UIKit

class PaddingLabel: UILabel {
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabel()
    }
    
    func configureLabel() {
        textEdgeInsets.left = 16
        textEdgeInsets.bottom = 4
        textEdgeInsets.right = 16
        textEdgeInsets.top = 4
        self.numberOfLines = 0
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.font = UIFont(name: "NotoSansKR", size: 14)
        self.textColor = .black
        self.lineBreakMode = .byWordWrapping
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
}
