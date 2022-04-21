//
//  TagDataStore.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/11.
//

import UIKit

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
