//
//  BaseInterceptor.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import Foundation
import Alamofire
class BaseInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() called")
        var request = urlRequest
        if Jwt.shared.accessToken != "" {
            request.setValue("Bearer " + Jwt.shared.accessToken, forHTTPHeaderField: "Authorization")
        }
        if REFRESHTOKEN != "" {
            request.setValue("REFRESH=" + REFRESHTOKEN, forHTTPHeaderField: "Cookie")
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        let data = ["statusCode" : statusCode]
        if statusCode == 401 {
            if REFRESHTOKEN != "" {
                MyAlamofireManager.shared.renewAccessToken() { bool in
                    if !bool {
                        let vc = SettingViewController()
                        vc.goToApp()
                    }
                }
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil, userInfo:  data)
        completion(.doNotRetry)
    }
}
