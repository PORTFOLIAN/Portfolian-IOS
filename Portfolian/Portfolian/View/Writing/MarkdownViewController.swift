//
//  MarkdownViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2022/05/18.
//

import UIKit

class MarkdownViewController: UIViewController {
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "마크다운 사용법"
        label.textColor = ColorPortfolian.thema
        label.font = UIFont(name: "NotoSansKR-Bold", size: 24)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var markdownScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.layer.borderWidth = 1
        scrollView.layer.cornerRadius = 20
        scrollView.layer.borderColor = ColorPortfolian.thema.cgColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    var markdownLabel: UILabel = {
        var label = UILabel()
        label.text = """
        *italics* or _italics_
        **bold** or __bold__
        ~~Linethrough~~Strikethroughs.
        `code`

        # Header 1

        or

        Header 1
        ====

        ## Header 2

        or

        Header 2
        ---

        ### Header 3
        #### Header 4
        ##### Header 5 #####
        ###### Header 6 ######

            Indented code blocks (spaces or tabs)

        [Links](http://voyagetravelapps.com/)
        ![Images](<Name of asset in bundle>)

        [Referenced Links][1]
        ![Referenced Images][2]

        [1]: http://voyagetravelapps.com/
        [2]: <Name of asset in bundle>

        > Blockquotes

        - Bulleted
        - Lists
            - Including indented lists
                - Up to three levels
        - Neat!

        1. Ordered
        1. Lists
            1. Including indented lists
                - Up to three levels
        """
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        view.addSubview(titleLabel)
        view.addSubview(markdownScrollView)
        markdownScrollView.addSubview(markdownLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor,constant: 10),
            
            markdownScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            markdownScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            markdownScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            markdownScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            markdownLabel.topAnchor.constraint(equalTo: markdownScrollView.topAnchor, constant: 10),
            markdownLabel.leadingAnchor.constraint(equalTo: markdownScrollView.leadingAnchor, constant: 10),
            markdownLabel.trailingAnchor.constraint(equalTo: markdownScrollView.trailingAnchor, constant: 10),
            markdownLabel.bottomAnchor.constraint(equalTo: markdownScrollView.bottomAnchor, constant:  -10)
        ])
    }
}
