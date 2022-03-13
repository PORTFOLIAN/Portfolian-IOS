//
//  ViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/17.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import CoreData

class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.kakaoAutoLogin()
    }
    
    private func kakaoAutoLogin() {
        let viewControllers : [UIViewController] = [
            initNavigationTabViewController("Home", identifier: "HomeVC", icon: UIImage(named: "Home"), tag: 1),
            initNavigationTabViewController("Bookmark", identifier: "BookmarkVC", icon: UIImage(named: "Bookmark"), tag: 2),
            initNavigationTabViewController("Chat", identifier: "ChatVC", icon: UIImage(named: "Chat"), tag: 3),
            initNavigationTabViewController("MyPage", identifier: "MyPageVC", icon: UIImage(named: "Mypage"), tag: 4)
        ]
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        
                        self.goToApp()
                        
                    }
                    else {
                        //기타 에러
                        print("에러 : \(error)")
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    
                    self.setViewControllers(viewControllers, animated: true)

                    let request: NSFetchRequest<Token> = Token.fetchRequest()
                    let fetchResult = PersistenceManager.shared.fetch(request: request)
                    fetchResult.forEach {
                        guard let accessToken = $0.accessToken else {return}
                        Jwt.shared.accessToken = accessToken
                        guard let refreshToken = $0.refreshToken else {return}
                        REFRESHTOKEN = refreshToken
                        guard let userId = $0.userId else {return}
                        Jwt.shared.userId = userId
                        }
                    
                    
                    MyAlamofireManager.shared.getMyProfile { response in
                        switch response {
                        case .success(let user):
                            ()
//                            if user.stackList != [] {
//                                for stack in user.stackList {
//                                    myTag.names.append(Tag.Name(rawValue: stack)!)
//                                }
//                            }
                        case .failure(let error):
                            print(error)
                        default:
                            break
                        }
                    }
                    
                }
            }
        } else {
            //로그인 필요
            self.goToApp()
        }
    }

    //MARK: Navigation
    private func goToApp() {
        
        let authView = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SigninVC")
        authView.modalPresentationStyle = .fullScreen
        self.present(authView, animated: true, completion: nil)
    }
    
}
