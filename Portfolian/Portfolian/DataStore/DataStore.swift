//
//  DataStore.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/11.
//

import Foundation
import UIKit
var registrationType: RegistrationType?
var editType: EditType?
var chatRootType: ChatRootType?
var profileType: ProfileType?
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


struct DataStore {
    var user: User?
}


struct TagDataStore {
    
    var names: [Tag.Name]
    
    init() {
        self.names = [Tag.Name]()
    }
}
var writingOwnerTag = TagDataStore()
var writingTeamTag = TagDataStore()
var searchingTag = TagDataStore()
var myTag = TagDataStore()
