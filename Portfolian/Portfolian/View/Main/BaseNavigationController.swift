//
//  BaseNavigationController.swift
//  Portfolian
//
//  Created by 이상현 on 2022/05/16.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    private var duringTransition = false
    private var disabledPopVCs = [ViewController.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringTransition = true

        super.pushViewController(viewController, animated: animated)
    }
    
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 1 {
            navigationController.tabBarController?.tabBar.isHidden = true
        }
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            navigationController.tabBarController?.tabBar.isHidden = false
        }
        self.duringTransition = false
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer,
              let topVC = topViewController else {
            return true
        }
        
        return viewControllers.count > 1 && duringTransition == false && isPopGestureEnable(topVC)
    }

    private func isPopGestureEnable(_ topVC: UIViewController) -> Bool {
        for vc in disabledPopVCs {
            if String(describing: type(of: topVC)) == String(describing: vc) {
                return false
            }
        }
        return true
    }
}
