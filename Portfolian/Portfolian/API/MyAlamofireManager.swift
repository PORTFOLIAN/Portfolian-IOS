//
//  AlamofireManager.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import Foundation
import Alamofire

final class MyAlamofireManager {
    // 싱글턴 사용
    static let shared = MyAlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
                                    [
                                        BaseInterceptor()
                                    ])
    
    // 로거 설정
        let monitors = [MyLogger()] as [EventMonitor]
    
    // 세션 설정
    var session : Session
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
