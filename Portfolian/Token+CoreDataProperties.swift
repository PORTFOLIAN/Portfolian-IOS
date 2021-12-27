//
//  Token+CoreDataProperties.swift
//  Portfolian
//
//  Created by 이상현 on 2021/12/21.
//
//

import Foundation
import CoreData


extension Token {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Token> {
        return NSFetchRequest<Token>(entityName: "Token")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var refreshToken: String?
    @NSManaged public var userId: String?
}

extension Token : Identifiable {

}
