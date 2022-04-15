//
//  BaseInterceptor.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import UIKit
import Alamofire

class BaseInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() called")
        var request = urlRequest
        if JwtToken.shared.accessToken != "" {
            request.setValue("Bearer " + JwtToken.shared.accessToken, forHTTPHeaderField: "Authorization")
        }
        if JwtToken.shared.refreshToken != "" {
            request.setValue("REFRESH=" + JwtToken.shared.refreshToken, forHTTPHeaderField: "Cookie")
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetryWithError(error))
            return
        }
        let data = ["statusCode" : statusCode]
//        if loginType != .no {
            if statusCode == 401 {
                MyAlamofireManager.shared.renewAccessToken() { bool in
                    if bool {
                        completion(.retry)
                    } else {
                        self.goToSignin()
                    }
                }
            } else if statusCode == 403 || statusCode == 404{
                self.goToSignin()
            }
//        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil, userInfo:  data)
        completion(.doNotRetry)
    }
    
    private func goToSignin() {
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.goToSignIn()
            }
        }
    }
}
