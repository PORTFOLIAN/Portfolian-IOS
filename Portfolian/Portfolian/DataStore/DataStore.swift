//
//  DataStore.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/11.
//

import Foundation
import UIKit
var registrationType: RegistrationType?

enum RegistrationType {
    case Searching
    case Writing
}

struct DataStore {
    var user: User?
}


struct TagDataStore {
    
    var names: [Tag.Name]
    
    init() {
        self.names = [Tag.Name]()
    }
    
    init(names: [Tag.Name], colors: [Tag.Color]) {
        self.names = names
    }
}


var writingTag = TagDataStore()
var searchingTag = TagDataStore()


