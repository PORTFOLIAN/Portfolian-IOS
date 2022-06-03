//
//  SceneDelegate.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/17.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
          if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
          }
        }
      }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Override point for customization after application launch.
        guard let windowScene = (scene as? UIWindowScene) else { return }
//        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
//
        KakaoSDKCommon.initSDK(appKey: "8ab6cd6b8425d701ee369a5b461275a8")
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.backgroundColor = .white
        let tabBarVC = ViewController()
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if loginType != .no {
            SocketIOManager.shared.establishConnection()
            SocketIOManager.shared.connectCheck { Bool in
                if Bool {
                    SocketIOManager.shared.sendAuth()
                }
            }
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        if loginType != .no {
            SocketIOManager.shared.closeConnection()
            print("socket disconnect")
        }
    }
    
    
    
    func goToSignIn() {
      window?.rootViewController = SigninViewController()
      window?.makeKeyAndVisible()
    }
    
    func goHome() {
      window?.rootViewController = ViewController()
      window?.makeKeyAndVisible()
    }
}
