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

        let viewControllers: [UIViewController] = [
            initNavigationTabViewController("Home", identifier: "HomeVC", icon: UIImage(named: "tabbarHome"), selectedIcon: UIImage(named: "tabbarHomeFill"), tag: 1),
            initNavigationTabViewController("Bookmark", identifier: "BookmarkVC", icon: UIImage(named: "tabbarBookmark"), selectedIcon: UIImage(named: "tabbarBookmarkFill"), tag: 2),
            initNavigationTabViewController("Chat", identifier: "ChatVC", icon: UIImage(named: "tabbarChat"), selectedIcon: UIImage(named: "tabbarChatFill"), tag: 3),
            initNavigationTabViewController("MyPage", identifier: "MyPageVC", icon: UIImage(named: "tabbarMyPage"), selectedIcon: UIImage(named: "tabbarMyPageFill"), tag: 4)
        ]

        switch loginType {
        case .kakao:
            kakaoAutoLogin(viewControllers: viewControllers)
        case .apple:
            appleAutoLogin (viewControllers: viewControllers)
        case .no:
            self.setViewControllers(viewControllers, animated: true)
        default:
            goToSiginIn()
        }
    }
    
    private func appleAutoLogin(viewControllers: [UIViewController]) {
        self.fetchToken() {
            MyAlamofireManager.shared.fetchIsBan {
                guard let fcmToken = KeychainManager.shared.read(key: "fcmToken") else {
                    self.goToSiginIn()
                return }
                MyAlamofireManager.shared.patchFcm(fcm: fcmToken) {
                    self.setViewControllers(viewControllers, animated: true)
                }
            }
        }
    }
    
    private func kakaoAutoLogin(viewControllers: [UIViewController]) {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { [weak self] (_, error) in
                guard let self = self else { return }
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        self.goToSiginIn()
                    }
                } else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    self.fetchToken() {
                        MyAlamofireManager.shared.fetchIsBan {
                            guard let fcmToken = KeychainManager.shared.read(key: "fcmToken") else {
                                self.goToSiginIn()
                            return }
                            MyAlamofireManager.shared.patchFcm(fcm: fcmToken) {
                                self.setViewControllers(viewControllers, animated: true)
                            }
                        }
                    }
                }
            }
        } else {
            // 로그인 창으로
            goToSiginIn()
        }
    }
    
    func fetchToken(completion: @escaping () -> Void) {
        guard let accessToken = KeychainManager.shared.read(key: "accessToken") else { return }
        guard let refreshToken = KeychainManager.shared.read(key: "refreshToken") else { return }
        guard let userId = KeychainManager.shared.read(key: "userId") else { return }
        JwtToken.shared.accessToken = accessToken
        JwtToken.shared.refreshToken = refreshToken
        JwtToken.shared.userId = userId
        completion()
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
