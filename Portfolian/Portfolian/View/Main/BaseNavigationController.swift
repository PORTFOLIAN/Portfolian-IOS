//
//  BaseNavigationController.swift
//  Portfolian
//
//  Created by 이상현 on 2022/05/16.
//

import UIKit
class BaseNavigationController: UINavigationController {
    var isSwipe = true

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
        
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if isSwipe {
            if viewControllers.count > 1 {
                viewController.tabBarController?.tabBar.isHidden = true
            }
            if viewControllers.count == 1 {
                navigationController.tabBarController?.tabBar.isHidden = false
            }
        } else {
            // 화면이 변하는가?
            if let coordinator = navigationController.topViewController?.transitionCoordinator {
                // 제스쳐가 변화하면 알려주는 메소드
                coordinator.notifyWhenInteractionChanges({ [weak self] (context) in
                    guard let self = self else { return }
                    if context.isCancelled {
                        self.isSwipe = true
                    } else {
                        if self.viewControllers.count == 1 {
                            navigationController.tabBarController?.tabBar.isHidden = false
                        }
                    }
                })
            }
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isSwipe = true
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count > 1 {
            isSwipe = false
            return true
        } else {
            return false
        }
    }
}
