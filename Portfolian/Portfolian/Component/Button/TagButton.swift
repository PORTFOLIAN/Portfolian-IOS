//
//  TagButton.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/22.
//

import UIKit

protocol TagToggleButtonDelegate {
    func didTouchTagButton(didClicked: Bool)
}

class TagButton: UIButton {
    var isClicked: Bool = false
    var delegate: TagToggleButtonDelegate?
    var subject: UIColor = ColorPortfolian.more
    @objc func tagButtonHandler(_ sender: UIButton) {
        switch registrationType {
        case .Writing:
            if self.backgroundColor == ColorPortfolian.more {
                if writingTag.names.count < 7 {
                    isClicked.toggle()
                    delegate?.didTouchTagButton(didClicked: isClicked)
                    self.backgroundColor = subject
                } else if writingTag.names.count == 7 {
                    self.alpha = 0.5
                    let time = DispatchTime.now() + .milliseconds(300)
                    DispatchQueue.main.asyncAfter(deadline: time) {
                        self.alpha = 1
                    }
                    print(writingTag.names)
                }
            } else {
                isClicked.toggle()
                delegate?.didTouchTagButton(didClicked: isClicked)
                // 회색(기본)
                self.backgroundColor = ColorPortfolian.more
            }
        case .Searching:
            isClicked.toggle()
            delegate?.didTouchTagButton(didClicked: isClicked)
            self.backgroundColor = subject
        default:
            break
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func setupLayout() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = ColorPortfolian.more
        self.addTarget(self, action: #selector(tagButtonHandler(_:)), for: .touchUpInside)
//        informTextInfo(text: "default", fontSize: 30)
    }
    
    func informTextInfo(text: String, fontSize: Int) {
        let text = String("  " + text + "  ")
        // text를 NSMutableAttribute를 만듦
        let textInfo = NSMutableAttributedString(string: text)
        // 색과 언더 라인을 추가
        textInfo.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))], range: NSRange(location: 0, length: text.count))
        // 버튼 속성 적용
        self.setAttributedTitle(textInfo, for: .normal)
        // 버튼 값 적용
    }
    
    func setColor(color: UIColor){
        subject = color
    }
    
    func currentColor(color: UIColor){
        self.backgroundColor = color
    }
}
