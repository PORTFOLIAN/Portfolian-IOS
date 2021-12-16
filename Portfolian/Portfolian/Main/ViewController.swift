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
class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let projectSearch = ProjectSearch(stackList: "default", sort: "default", keyword: "default")
        MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
            switch result {
            case .success(let articleList):
                print(12341234)
                let articleList = articleList
            case .failure:
                print("error?")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kakaoAutoLogin()
    }
    private func kakaoAutoLogin() {
        let viewControllers : [UIViewController] = [
            initNavigationTabViewController("Home", identifier: "HomeVC", icon: UIImage(named: "Home"), tag: 1),
            initNavigationTabViewController("Bookmark", identifier: "BookmarkVC", icon: UIImage(named: "Bookmark"), tag: 2),
            initNavigationTabViewController("Chat", identifier: "ChatVC", icon: UIImage(named: "Chat"), tag: 3),
            initNavigationTabViewController("MyPage", identifier: "MyPageVC", icon: UIImage(named: "Mypage"), tag: 4)
        ]
        print("가")
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        print("나")
                        self.goToApp()
                    }
                    else {
                        //기타 에러
                        print("나")
                        print("에러 : \(error)")
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    print("다")
                    
                    self.setViewControllers(viewControllers, animated: true)
                }
            }
        } else {
            //로그인 필요
            print("라")
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
