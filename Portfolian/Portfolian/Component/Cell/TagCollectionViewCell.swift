//
//  TagCollectionViewCell.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/11.
//

import UIKit
import SnapKit

class TagCollectionViewCell: UICollectionViewCell {
    var index = Int()
    let tagButton = TagButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
//        contentView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(tagButton)

        tagButton.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        tagButton.delegate = self // 버튼 클릭했을때 데이터를 넘겨받아야 함
    }    
    
    func configure(tagName: String, tagColor: UIColor, index: Int) {
        print("configure")
        // tag들의 이름을 지정해줌
        tagButton.informTextInfo(text: tagName, fontSize: 16)
        // tag의 색을 지정해줌
        tagButton.setColor(color: tagColor)
        self.index = index
        print(writingTag.names)
        guard let clickedTags = initState() else { return }
        
        if clickedTags {
            tagButton.isClicked = true
            tagButton.currentColor(color: tagColor)
        }
    }
    
    // 등록 타입별로 상태 초기화
    func initState() -> Bool? {
        let clickedTags: Bool?
        switch registrationType {
        case .Writing:
            clickedTags = writingTag.names.contains(Tag.Name.allCases[index])
        case .Searching:
            clickedTags = searchingTag.names.contains(Tag.Name.allCases[index])
           
        default:
            return nil
        }
        
        return clickedTags
    }

    
    func storeWritingData(didClicked: Bool) {
        print(didClicked)
        if didClicked {
            writingTag.names.append(Tag.Name.allCases[self.index])
            
        } else {
            guard let nameIndex = writingTag.names
                    .firstIndex(of: Tag.Name.allCases[self.index])
            else { return }
            
            writingTag.names.remove(at: nameIndex)
            
        }
        print(writingTag.names)
    }
    
    func storeSearchingData(didClicked: Bool) {
        
        if didClicked {
            searchingTag.names.append(Tag.Name.allCases[self.index])
            
        } else {
            guard let nameIndex = writingTag.names
                    .firstIndex(of: Tag.Name.allCases[self.index])
            else { return }
            
            searchingTag.names.remove(at: nameIndex)
            
        }
        print(searchingTag.names)

    }
    
    
}




extension TagCollectionViewCell: TagToggleButtonDelegate {
    
    func didTouchTagButton(didClicked: Bool) {
            switch registrationType {
            case .Writing:
                storeWritingData(didClicked: didClicked)
            case .Searching:
                storeSearchingData(didClicked: didClicked)
            default:
                break
        }
    }
}
