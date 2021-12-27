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
        // tag들의 이름을 지정해줌
        tagButton.informTextInfo(text: tagName, fontSize: 16)
        // tag의 색을 지정해줌
        tagButton.setColor(color: tagColor)
        self.index = index
        // 데이터스토어에 저장된 태그 init.
        guard let clickedTags = initState() else { return }
        if clickedTags {
            tagButton.isClicked = true
        }
        
        
    }
    
    // 등록 타입별로 상태 초기화
    func initState() -> Bool? {
        let clickedTags: Bool?
        switch registrationType {
            
        case .WritingTeam:
            clickedTags = writingTeamTag.names.contains(Tag.Name.allCases[index])
        case .WritingOwner:
            clickedTags = writingOwnerTag.names.contains(Tag.Name.allCases[index])
        case .Searching:
            clickedTags = searchingTag.names.contains(Tag.Name.allCases[index])
        case .MyPage:
            clickedTags = myTag.names.contains(Tag.Name.allCases[index])
        default:
            return true
        }
        return clickedTags
    }

    func storeWritingData(didClicked: Bool) {
        if didClicked {
            writingOwnerTag.names.append(Tag.Name.allCases[self.index])
        } else {
            guard let nameIndex = writingOwnerTag.names
                    .firstIndex(of: Tag.Name.allCases[self.index])
            else { return }
            writingOwnerTag.names.remove(at: nameIndex)
        }
    }
    
    func storeWritingTeamData(didClicked: Bool) {
        if didClicked {
            writingTeamTag.names.append(Tag.Name.allCases[self.index])

        } else {
            guard let nameIndex = writingTeamTag.names
                    .firstIndex(of: Tag.Name.allCases[self.index])
            else { return }
            writingTeamTag.names.remove(at: nameIndex)
        }
    }
    
    func storeSearchingData(didClicked: Bool) {
        if didClicked {
            searchingTag.names.append(Tag.Name.allCases[self.index])
        } else {
            guard let nameIndex = searchingTag.names
                    .firstIndex(of: Tag.Name.allCases[self.index])
            else { return }
            searchingTag.names.remove(at: nameIndex)
        }
        
        
    }
    func storeMyPageData(didClicked: Bool) {
        if didClicked {
            myTag.names.append(Tag.Name.allCases[self.index])
        } else {
            guard let nameIndex = myTag.names
                    .firstIndex(of: Tag.Name.allCases[self.index])
            else { return }
            myTag.names.remove(at: nameIndex)
        }
        
        
    }
}

extension TagCollectionViewCell: TagToggleButtonDelegate {
    func didTouchTagButton(didClicked: Bool) {
            switch registrationType {
            case .WritingTeam:
                storeWritingTeamData(didClicked: didClicked)
            case .WritingOwner:
                storeWritingData(didClicked: didClicked)
            case .Searching:
                storeSearchingData(didClicked: didClicked)
            case .Writing:
                storeWritingData(didClicked: didClicked)
                storeWritingTeamData(didClicked: didClicked)
            default:
                storeMyPageData(didClicked: didClicked)
                
        }
    }
}
