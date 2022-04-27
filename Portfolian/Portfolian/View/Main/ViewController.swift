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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginType = LoginType(rawValue: UserDefaults.standard.integer(forKey: "loginType"))
        switch loginType {
        case .kakao:
            kakaoAutoLogin()
        case .no:
            let viewControllers: [UIViewController] = [
                initNavigationTabViewController("Home", identifier: "HomeVC", icon: UIImage(named: "home"), tag: 1),
                initNavigationTabViewController("Bookmark", identifier: "BookmarkVC", icon: UIImage(named: "bookmark"), tag: 2),
                initNavigationTabViewController("Chat", identifier: "ChatVC", icon: UIImage(named: "chat"), tag: 3),
                initNavigationTabViewController("MyPage", identifier: "MyPageVC", icon: UIImage(named: "myPage"), tag: 4)
            ]
            self.setViewControllers(viewControllers, animated: true)
        default:
            goToSiginIn()
        }
    }
    
    private func kakaoAutoLogin() {
        let viewControllers: [UIViewController] = [
            initNavigationTabViewController("Home", identifier: "HomeVC", icon: UIImage(named: "home"), tag: 1),
            initNavigationTabViewController("Bookmark", identifier: "BookmarkVC", icon: UIImage(named: "bookmark"), tag: 2),
            initNavigationTabViewController("Chat", identifier: "ChatVC", icon: UIImage(named: "chat"), tag: 3),
            initNavigationTabViewController("MyPage", identifier: "MyPageVC", icon: UIImage(named: "myPage"), tag: 4)
        ]
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, _) in
                //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                self.fetchToken()
                self.setViewControllers(viewControllers, animated: true)
            }
        } else {
            // 로그인 창으로
            goToSiginIn()
        }
    }
    
    func fetchToken() {
        guard let accessToken = KeychainManager.shared.read(key: "accessToken") else { return }
        guard let refreshToken = KeychainManager.shared.read(key: "refreshToken") else { return }
        guard let userId = KeychainManager.shared.read(key: "userId") else { return }
        JwtToken.shared.accessToken = accessToken
        JwtToken.shared.refreshToken = refreshToken
        JwtToken.shared.userId = userId
    }
        
    private func goToSiginIn() {
      if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
        sceneDelegate.goToSignIn()
      }
    }
    
    private func goHome() {
      if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
        sceneDelegate.goHome()
      }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 4 {
            profileType = .myProfile
        }
        if item.tag == 1 {
            profileType = .yourProjectProfile
        }
    }
}
