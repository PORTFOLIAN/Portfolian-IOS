//
//  FilterViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/22.
//

import UIKit
import Then
import SnapKit

class FilterViewController: UIViewController {
    let identifier = "TagCollectionViewCell"
    
    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedCollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        self.title = "태그 필터"
        addSubview()
        setupAutoLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    //MARK: - setupAutoLayout
    func setupAutoLayout() {
//        definesPresentationContext = true

        tagCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    //MARK: - addSubview
    func addSubview() {
        view.addSubview(tagCollectionView)
    }
    
    
    
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingRow)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingColumn)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 더비 라벨을 만들어줘서 크기를 버튼의 크기를 예상하여 넣어준다.
        let tag = Tag.Name.allCases[indexPath.row]
        let tagInfo = getTagInfo(tag: tag)
        let tagName = tagInfo.name
        let label = TagButton().then {
            $0.informTextInfo(text: tagName, fontSize: 16)
            $0.sizeToFit()
        }
        let size = label.frame.size
        
        return CGSize(width: size.width, height: size.height + 10)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        //        TagCOllectionViewCell에서 contentView.isUserInteractionEnabled = true 해주면 함수 동작함. 대신 색이 안 나옴.
    }
}

extension FilterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Tag.Name.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
        let tag = Tag.Name.allCases[indexPath.row]
        let tagInfo = getTagInfo(tag: tag)
        let tagName = tagInfo.name
        let tagColor = tagInfo.color
        cell.configure(tagName: tagName, tagColor: tagColor, index: tag.index)
        return cell
    }
    
    func getTagInfo(tag: Tag.Name) -> TagInfo {
        switch tag {
        case .frontEnd  : return TagInfo(name: "Front-end", color: ColorPortfolian.frontEnd)
        case .backEnd   : return TagInfo(name: "Back-end", color: ColorPortfolian.backEnd)
        case .react     : return TagInfo(name: "React", color: ColorPortfolian.react)
        case .spring    : return TagInfo(name: "Spring", color: ColorPortfolian.spring)
        case .django    : return TagInfo(name: "Django", color: ColorPortfolian.django)
        case .javascript: return TagInfo(name: "Javascript", color: ColorPortfolian.javascript)
        case .typescript: return TagInfo(name: "Typescript", color: ColorPortfolian.typescript)
        case .ios       : return TagInfo(name: "iOS", color: ColorPortfolian.ios)
        case .android   : return TagInfo(name: "Andriod", color: ColorPortfolian.android)
        case .angular   : return TagInfo(name: "Angular", color: ColorPortfolian.angular)
        case .htmlCss   : return TagInfo(name: "HTML/CSS", color: ColorPortfolian.htmlCss)
        case .flask     : return TagInfo(name: "Flask", color: ColorPortfolian.flask)
        case .nodeJs    : return TagInfo(name: "Node.js", color: ColorPortfolian.nodeJs)
        case .java      : return TagInfo(name: "Java", color: ColorPortfolian.java)
        case .python    : return TagInfo(name: "Python", color: ColorPortfolian.python)
        case .kotlin    : return TagInfo(name: "Kotlin", color: ColorPortfolian.kotlin)
        case .swift     : return TagInfo(name: "Swift", color: ColorPortfolian.swift)
        case .go        : return TagInfo(name: "Go", color: ColorPortfolian.go)
        case .cCpp      : return TagInfo(name: "C/C++", color: ColorPortfolian.cCpp)
        case .cCsharp   : return TagInfo(name: "C#", color: ColorPortfolian.cCsharp)
        case .design    : return TagInfo(name: "Design", color: ColorPortfolian.design)
        case .figma     : return TagInfo(name: "Figma", color: ColorPortfolian.figma)
        case .sketch    : return TagInfo(name: "Sketch", color: ColorPortfolian.sketch)
        case .adobeXD   : return TagInfo(name: "adobeXD", color: ColorPortfolian.adobeXD)
        case .photoshop : return TagInfo(name: "Photoshop", color: ColorPortfolian.photoshop)
        case .illustrator: return TagInfo(name: "Illustrator", color: ColorPortfolian.illustrator)
        case .firebase  : return TagInfo(name: "Firebase", color: ColorPortfolian.firebase)
        case .aws       : return TagInfo(name: "AWS", color: ColorPortfolian.aws)
        case .gcp       : return TagInfo(name: "GCP", color: ColorPortfolian.gcp)
        case .git       : return TagInfo(name: "Git", color: ColorPortfolian.git)
        case .etc       : return TagInfo(name: "etc", color: ColorPortfolian.etc)
        }
    }
}

struct TagInfo {
    let name: String
    let color: UIColor
}
