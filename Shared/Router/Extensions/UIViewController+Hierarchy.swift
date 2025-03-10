//
//  UIViewController+Hierarchy.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import UIKit

extension UIViewController {
    func findTopViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.findTopViewController()
        }
        
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.findTopViewController() ?? nav
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.findTopViewController() ?? tab
        }
        
        return self
    }
}
