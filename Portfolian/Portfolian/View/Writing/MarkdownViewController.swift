//
//  MarkdownViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2022/05/18.
//

import UIKit
import SwiftyMarkdown
class MarkdownViewController: UIViewController {
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "마크다운 사용법"
        label.textColor = ColorPortfolian.thema
        label.font = UIFont(name: "NotoSansKR-Bold", size: 24)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.layer.borderWidth = 1
        scrollView.layer.cornerRadius = 20
        scrollView.layer.borderColor = ColorPortfolian.thema.cgColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var markdownScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.layer.borderWidth = 1
        scrollView.layer.cornerRadius = 20
        scrollView.layer.borderColor = ColorPortfolian.thema.cgColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var testLabel: UILabel = {
        var label = UILabel()
        label.text = markdownInit
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var markdownLabel: UILabel = {
        var label = UILabel()
        label.text = markdownInit
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        view.addSubview(markdownScrollView)
        scrollView.addSubview(testLabel)
        markdownScrollView.addSubview(markdownLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor,constant: 10),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            scrollView.heightAnchor.constraint(equalToConstant: view.frame.height/2 - 100),

            testLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            testLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            testLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 10),
            testLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant:  -10),
            
            markdownScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            markdownScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            markdownScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            markdownScrollView.heightAnchor.constraint(equalToConstant: view.frame.height/2 - 100),
            
            markdownLabel.topAnchor.constraint(equalTo: markdownScrollView.topAnchor, constant: 10),
            markdownLabel.leadingAnchor.constraint(equalTo: markdownScrollView.leadingAnchor, constant: 10),
            markdownLabel.trailingAnchor.constraint(equalTo: markdownScrollView.trailingAnchor, constant: 10),
            markdownLabel.bottomAnchor.constraint(equalTo: markdownScrollView.bottomAnchor, constant:  -10)
        ])
        configureLabel()
    }
    
    fileprivate func configureLabel() {
        let md = SwiftyMarkdown(string: "\n" + (testLabel.text ?? ""))
        markdownLabel.attributedText = md.attributedString()
        guard let messageText = markdownLabel.text else { return }
        let mutableString = NSMutableAttributedString()
        
        var urlAttributes: [NSMutableAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.italicSystemFont(ofSize: 16)
        ]
        
        // swiftyMarkdown
        let normalText = md.attributedString()
        mutableString.append(normalText)
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(
                in: messageText,
                options: [],
                range: NSRange(location: 0, length: messageText.count)
            )
            
            for m in matches {
                if let url = m.url {
                    urlAttributes[.link] = url
                    mutableString.setAttributes(urlAttributes, range: m.range)
                }
            }
            markdownLabel.attributedText = mutableString
        } catch {
            print(error)
        }
    }
}
