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
}

struct TagInfo {
    let name: String
    let color: UIColor
}
