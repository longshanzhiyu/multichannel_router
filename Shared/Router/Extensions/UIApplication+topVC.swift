//
//  UIApplication+TopVC.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import UIKit

// MARK: - 扩展支持
extension UIApplication {
    var topViewController: UIViewController? {
        guard let windowScene = connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene else { return nil }
        
        return windowScene.windows
            .first(where: \.isKeyWindow)?
            .rootViewController?
            .findTopViewController()
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

