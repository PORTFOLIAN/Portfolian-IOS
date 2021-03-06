//
//  TagButton.swift
//  Portfolian
//
//  Created by μ΄μν on 2021/10/22.
//

import UIKit
import Toast_Swift
protocol TagToggleButtonDelegate {
    func didTouchTagButton(didClicked: Bool)
}

class TagButton: UIButton {
    var isClicked: Bool = false {
        didSet {
            if isClicked == true {
                self.backgroundColor = subject
            } else {
                self.backgroundColor = ColorPortfolian.more
            }
        }
    }
    var delegate: TagToggleButtonDelegate?
    var subject: UIColor = ColorPortfolian.more
    @objc func tagButtonHandler(_ sender: UIButton) {
        isClicked.toggle()
        delegate?.didTouchTagButton(didClicked: isClicked)
        switch registrationType {
        case .WritingOwner:
            if writingOwnerTag.names.count > 1 {
                isClicked.toggle()
                delegate?.didTouchTagButton(didClicked: isClicked)

                self.alpha = 0.5
                let time = DispatchTime.now() + .milliseconds(300)
                window?.rootViewController?.view.makeToast("π νκ·Έλ μ΅λ 1κ°κΉμ§ μ§μ ν  μ μμ΅λλ€.", duration: 1.0, position: .center)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    self.alpha = 1
                }
            }
        case .WritingTeam:
            if writingTeamTag.names.count > 7 {
                isClicked.toggle()
                delegate?.didTouchTagButton(didClicked: isClicked)

                self.alpha = 0.5
                let time = DispatchTime.now() + .milliseconds(300)
                window?.rootViewController?.view.makeToast("π νκ·Έλ μ΅λ 7κ°κΉμ§ μ§μ ν  μ μμ΅λλ€.", duration: 1.0, position: .center)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    self.alpha = 1
                }
            }
        case .Searching:
            if searchingTag.names.count > 1 {
                isClicked.toggle()
                delegate?.didTouchTagButton(didClicked: isClicked)

                self.alpha = 0.5
                let time = DispatchTime.now() + .milliseconds(300)
                window?.rootViewController?.view.makeToast("π νκ·Έλ μ΅λ 1κ°κΉμ§ κ²μν  μ μμ΅λλ€.", duration: 1.0, position: .center)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    self.alpha = 1
                }
            }
        default:
            if myTag.names.count > 7 {
                isClicked.toggle()
                delegate?.didTouchTagButton(didClicked: isClicked)

                self.alpha = 0.5
                let time = DispatchTime.now() + .milliseconds(300)
                window?.rootViewController?.view.makeToast("π νκ·Έλ μ΅λ 7κ°κΉμ§ μ§μ ν  μ μμ΅λλ€.", duration: 1.0, position: .center)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    self.alpha = 1
                }
            }
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
        // textλ₯Ό NSMutableAttributeλ₯Ό λ§λ¦
        let textInfo = NSMutableAttributedString(string: text)
        // μκ³Ό μΈλ λΌμΈμ μΆκ°
        textInfo.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))], range: NSRange(location: 0, length: text.count))
        // λ²νΌ μμ± μ μ©
        self.setAttributedTitle(textInfo, for: .normal)
        // λ²νΌ κ° μ μ©
    }
    
    func setColor(color: UIColor){
        subject = color
    }
    
    func currentColor(color: UIColor){
        self.backgroundColor = color
    }
}
