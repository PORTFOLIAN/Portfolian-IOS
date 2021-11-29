//
//  Tag.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/11.
//

import UIKit

struct Tag {
    // 개체들
    enum Name: String, CaseIterable {
        case frontEnd
        case backEnd
        case react
        case spring
        case django
        case javascript
        case typescript
        case ios
        case android
        case angular
        case htmlCss
        case flask
        case nodeJs
        case java
        case python
        case kotlin
        case swift
        case go
        case cCpp
        case cCsharp
        case design
        case figma
        case sketch
        case adobeXD
        case photoshop
        case illustrator
        case firebase
        case aws
        case gcp
        case git
        case etc

        // 각 case의 인덱스
        var index: Self.AllCases.Index! {
            return Self.allCases.firstIndex { self == $0 }
        }
    }
    
    enum Color: String, CaseIterable {
        case frontEnd
        case backEnd
        case react
        case spring
        case django
        case javascript
        case typescript
        case ios
        case android
        case angular
        case htmlCss
        case flask
        case nodeJs
        case java
        case python
        case kotlin
        case swift
        case go
        case cCpp
        case cCsharp
        case design
        case figma
        case sketch
        case adobeXD
        case photoshop
        case illustrator
        case firebase
        case aws
        case gcp
        case git
        case etc
        case gray1
        case gray2
        
        // 각 case의 인덱스
        var index: Self.AllCases.Index! {
            return Self.allCases.firstIndex { self == $0 }
        }
    }
    
    static var shared = Tag()
    
    func getTagInfo(tag: Tag.Name?) -> TagInfo {
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
        default         : return TagInfo(name: "", color: ColorPortfolian.more)
        }
    }
}

struct TagInfo {
    let name: String
    let color: UIColor
}
