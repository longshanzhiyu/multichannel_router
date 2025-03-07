//
//  UIApplication+topVC.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/7.
//

import UIKit

extension UIApplication {
    /// 获取当前顶层视图控制器（兼容 iOS 13+）
    var topViewController: UIViewController? {
        guard let windowScene = connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene else {
            return nil
        }
        
        return windowScene.windows
            .first(where: \.isKeyWindow)?
            .rootViewController?
            .findTopViewController()
    }
}

extension UIViewController {
    /// 递归查找顶层视图控制器
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

extension UIApplication {
    enum TopViewControllerError: Error {
        case noActiveWindowScene
        case noKeyWindow
        case noRootViewController
    }
    
    func safeTopViewController() throws -> UIViewController {
        guard let windowScene = connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene else {
            throw TopViewControllerError.noActiveWindowScene
        }
        
        guard let keyWindow = windowScene.windows.first(where: \.isKeyWindow) else {
            throw TopViewControllerError.noKeyWindow
        }
        
        guard let rootVC = keyWindow.rootViewController else {
            throw TopViewControllerError.noRootViewController
        }
        
        return rootVC.findTopViewController()
    }
}
