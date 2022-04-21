//
//  TypeStore.swift
//  Portfolian
//
//  Created by 이상현 on 2022/04/21.
//

import Foundation

enum LoginType: Int {
    case kakao
    case apple
    case no
}

enum RegistrationType {
    case Searching
    case WritingTeam
    case WritingOwner
    case Writing
    case MyPage
}

enum EditType {
    case edit
    case yet
}

enum ChatRootType {
    case project
    case chatRoom
}

enum ProfileType {
    case myProfile
    case yourProfile
    case yourProjectProfile
}

var registrationType: RegistrationType?
var editType: EditType?
var chatRootType: ChatRootType?
var profileType: ProfileType?
var loginType: LoginType?
