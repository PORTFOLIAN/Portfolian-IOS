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
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwipeGesture(_  gesture: UISwipeGestureRecognizer) {
        if viewControllers.count == 1 {
            guard let tabBarController = tabBarController else { return }
            var toIndex = 0
            if gesture.direction == .left {
                if (tabBarController.selectedIndex) < 3 {
                    toIndex = tabBarController.selectedIndex + 1
                } else {
                    toIndex = 0
                }
                animateToTab(toIndex: toIndex, direction: .left)
            } else if gesture.direction == .right {
                if (tabBarController.selectedIndex) > 0 {
                    toIndex = tabBarController.selectedIndex - 1
                } else {
                    toIndex = 3
                }
                animateToTab(toIndex: toIndex, direction: .right)
            }
        }
    }
    func animateToTab(toIndex: Int, direction: UISwipeGestureRecognizer.Direction) {
        guard let selectedVC = tabBarController!.selectedViewController,
              let tabViewControllers = tabBarController!.viewControllers,
              let fromView = selectedVC.view,
              let toView = tabViewControllers[toIndex].view,
              let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
              fromIndex != toIndex else { return }
        fromView.superview?.addSubview(toView)
        
        let screenWidth = UIScreen.main.bounds.size.width
        var scrollRight = true
        if direction == .right {
            scrollRight = false
        }
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut) {
            fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
            toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
        } completion: { [weak self] finished in
            guard let self = self else { return }
            fromView.removeFromSuperview()
            self.tabBarController!.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        }
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
