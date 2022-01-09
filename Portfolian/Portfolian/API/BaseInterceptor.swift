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
        
        print(request)
//        request.addValue("application/json; charset = utf-8", forHTTPHeaderField: "Content-Type")
        // 공통 파라매터 추가
//        var dictionary = [String : String]()
//        dictionary.updateValue(API.USER_ID, forKey: "user_id")
//
//        do {
//            request = try URLEncodedFormParameterEncoder().encode(dictionary, into: request)
//        } catch {
//            print(error)
//        }
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
            MyAlamofireManager.shared.renewAccessToken()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil, userInfo:  data)
        completion(.doNotRetry)
    }
}
