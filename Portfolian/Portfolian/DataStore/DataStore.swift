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
    var colors: [Tag.Color]
    
    init() {
        self.names = [Tag.Name]()
        self.colors = [Tag.Color]()
    }
    
    init(names: [Tag.Name], colors: [Tag.Color]) {
        self.names = names
        self.colors = colors
    }
}

var writingTag = TagDataStore()
var searchingTag = TagDataStore()


