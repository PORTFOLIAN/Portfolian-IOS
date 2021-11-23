//
//  Writing+CoreDataProperties.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/24.
//
//

import Foundation
import CoreData


extension Writing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Writing> {
        return NSFetchRequest<Writing>(entityName: "Writing")
    }

    @NSManaged public var detail: String?
    @NSManaged public var explain: String?
    @NSManaged public var option: String?
    @NSManaged public var period: String?
    @NSManaged public var proceed: String?
    @NSManaged public var recruit: Int16
    @NSManaged public var tags: [String]?
    @NSManaged public var title: String?

}

extension Writing : Identifiable {

}
