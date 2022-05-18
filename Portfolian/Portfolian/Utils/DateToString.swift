//
//  DateToString.swift
//  Portfolian
//
//  Created by 이상현 on 2022/05/18.
//

import Foundation

public func DateToString(dateStr: String, afterFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: dateStr)
    let myDateFormatter = DateFormatter()
    myDateFormatter.dateFormat = afterFormat
    return myDateFormatter.string(from: date!)
}
