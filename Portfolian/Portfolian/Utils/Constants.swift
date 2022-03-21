//
//  Constants.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/22.
//

import Foundation
import UIKit
import GoogleSignIn
let SPACINGROW = 20
let SPACINGCOL = 10
let IDENTIFIER = "TagCollectionViewCell"
var SEARCHTOGGLE : Bool = true
var REFRESHTOKEN = ""
enum API {
    static let BASE_URL : String = "https://api.portfolian.site:443/"
    static let USER_ID : String = "test1"
}

enum SocketIO {
    static let BASE_URL : String = "http://3.36.84.11:3001/"
}

enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}
struct ColorPortfolian {
    
    // MARK: - TagColor
    /// TextField, TextView 배경 색
    static let frontEnd = UIColor(rgb: 0xAACFF2)
    static let backEnd = UIColor(rgb: 0xFFE58A)
    static let react = UIColor(rgb: 0xD0FDFD)
    static let vue = UIColor(rgb: 0xB4E8D2)
    static let spring = UIColor(rgb: 0xC5F8C7)
    static let django = UIColor(rgb: 0x93C59B)
    static let javascript = UIColor(rgb: 0xFFF38A)
    static let typescript = UIColor(rgb: 0xC9E3FB)
    static let ios = UIColor(rgb: 0xFFBBB7)
    static let android = UIColor(rgb: 0xAFF2AA)
    static let more = UIColor(rgb: 0xEAEAEA)
    static let angular = UIColor(rgb: 0xECA0A0)
    static let htmlCss = UIColor(rgb: 0xEDE4FF)
    static let flask = UIColor(rgb: 0xACACB4)
    static let nodeJs = UIColor(rgb: 0xD5F6C1)
    static let java = UIColor(rgb: 0xF4D8D8)
    static let python = UIColor(rgb: 0xC0CCF8)
    static let kotlin = UIColor(rgb: 0xFBCDB9)
    static let swift = UIColor(rgb: 0xFFDEB7)
    static let go = UIColor(rgb: 0xC1EDF6)
    static let cCpp = UIColor(rgb: 0xDEE7FE)
    static let cCsharp = UIColor(rgb: 0xCAB7FF)
    static let design = UIColor(rgb: 0xFBE1F8)
    static let figma = UIColor(rgb: 0xC1B7FF)
    static let sketch = UIColor(rgb: 0xFFF9C3)
    static let adobeXD = UIColor(rgb: 0xFFB7F8)
    static let photoshop = UIColor(rgb: 0xC9E3FB)
    static let illustrator = UIColor(rgb: 0xCFC3AC)
    static let firebase = UIColor(rgb: 0xFFEDAE)
    static let aws = UIColor(rgb: 0xF8C488)
    static let gcp = UIColor(rgb: 0xF9E686)
    static let git = UIColor(rgb: 0xC1D2ED)
    static let etc = UIColor(rgb: 0x5C5C5C)
    static let gray1 = UIColor(rgb: 0x909090)
    static let gray2 = UIColor(rgb: 0xCCCCCC)
    static let thema = UIColor(rgb: 0x6F9ACD)
}
