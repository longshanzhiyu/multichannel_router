//
//  AppInit.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/7.
//

class AppInit {
    // 注册路由
    static let profileRoute = Route<UserProfileParams>(
        path: "/user/profile",
        transition: .push(animated: true),
        handler: { params in
            return UserProfileViewController(userId: params.userId, isVIP: params.isVIP)
        }
    )
    
}
