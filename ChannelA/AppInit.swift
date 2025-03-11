//
//  AppInit.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/7.
//

import UIKit

class AppInit {
    // 注册路由
//    static let profileRoute = Route<UserProfileParams>(
//        path: "/user/profile",
//        transition: .custom(animator: FadeTransitionAnimator()),  // 使用淡入淡出动画
//        handler: { params in
//            return UserProfileViewController(userId: params.userId, isVIP: params.isVIP)
//        }
//    )
//    
//    static let settingsRoute = Route<EmptyParams>(
//        path: "/settings",
//        transition: .custom(animator: SlideTransitionAnimator(direction: .right)),  // 使用右侧滑入动画
//        handler: { _ in
//            return SettingsViewController()
//        }
//    )
    
    static let profileRoute = Route<UserProfileParams>(
        path: "/user/profile",
        transition: .push(animated: true),
        handler: { params in
            return UserProfileViewController(userId: params.userId, isVIP: params.isVIP)
        }
    )
    
    static let settingsRoute = Route<SettingsParams>(
        path: "/app/settings",
        transition: .present(animated: true, style: .fullScreen), // 关键present配置
        handler: { params in
            let vc = SettingsViewController(selectedSection: params.section, requiresAuthentication: params.requiresAuth)
            return vc
        }
    )
    
    static let productRoute = Route<ProductParams>(
        path: "/products/detail",
        transition: .push(animated: true),
        handler: { params in
            return ProductViewController(id: params.productId, variant: params.variant)
        }
    )
    
    static let switchHomeRoute = Route<EmptyParams>(
        path: "/tab/home",
        transition: .switchTab(index: 0)
    )

    // 按标识符切换
    static let switchProfileRoute = Route<EmptyParams>(
        path: "/tab/profile",
        transition: .switchTabByIdentifier("profile"),
        handler: { _ in
            return UIViewController()
        }
    )

    static func setupRoutes() {
        
        Router.register(productRoute)
        Router.register(profileRoute)
        Router.register(settingsRoute)
        Router.register(switchHomeRoute)
        Router.register(switchProfileRoute)
    }
    
    
}
