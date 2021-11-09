//
//  UITAbBarController+Tag.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/19.
//

import UIKit

extension UITabBarController {
    func initTabViewController(_ bundleName: String, identifier: String, icon: UIImage?, tag: Int) -> UIViewController{
        let viewController = UIStoryboard(name: bundleName, bundle: nil).instantiateViewController(withIdentifier: identifier)
        viewController.tabBarItem = UITabBarItem(title: title, image: icon, tag: tag)
        return viewController
    }
    
    func initNavigationTabViewController(_ bundleName: String, identifier: String, icon: UIImage?, tag: Int) -> UINavigationController{
        let viewController = UIStoryboard(name: bundleName, bundle: nil).instantiateViewController(withIdentifier: identifier)
        let navigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: "", image: icon, tag: tag)
        return navigationController
    }
}
