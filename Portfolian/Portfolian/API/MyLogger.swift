//
//  File.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import Foundation
import Alamofire
import UIKit

final class MyLogger : EventMonitor {
    let queue = DispatchQueue(label: "MyLogger")
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume()")
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request.didParseResponse()")
        debugPrint(response)
    }
}
