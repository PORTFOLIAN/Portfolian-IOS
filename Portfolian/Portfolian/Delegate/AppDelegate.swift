//
//  AppDelegate.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/17.
//

import UIKit
import SocketIO
import Firebase
import UserNotifications
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        self.askNotificationPermission(application)
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }
            else if let token = token {
                print("FCM registration token: \(token)")
                fcm = token
            }
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    private func askNotificationPermission(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        fcm = fcmToken!
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    // 알림이 도착했을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.identifier == "firstPush" {
            let userInfo = notification.request.content.userInfo
            print(userInfo)
        }
        print("메시지 수신")
        completionHandler([.list, .badge, .sound])
    }

    // 백그라운드인 경우 & 사용자가 푸시를 클릭한 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}
