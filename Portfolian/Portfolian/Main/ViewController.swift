//
//  ViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/17.
//

import UIKit

class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.tintColor = UIColor(rgb: 0x6F9ACD)
        let viewControllers : [UIViewController] = [
            initNavigationTabViewController("Home", identifier: "HomeVC", icon: UIImage(named: "Home"), tag: 1),
            initNavigationTabViewController("Bookmark", identifier: "BookmarkVC", icon: UIImage(named: "Bookmark"), tag: 2),
            initNavigationTabViewController("Chat", identifier: "ChatVC", icon: UIImage(named: "Chat"), tag: 3),
            initNavigationTabViewController("Mypage", identifier: "MypageVC", icon: UIImage(named: "Mypage"), tag: 4)
        ]
        self.setViewControllers(viewControllers, animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if User.shared.flag == false {
            goToApp()

        } else {

        }
    }
//    
    
    //MARK: Navigation
    private func goToApp() {
        let authView = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SigninVC")
        authView.modalPresentationStyle = .fullScreen
        self.present(authView, animated: true, completion: nil)
    }
    
}
