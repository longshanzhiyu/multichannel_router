//
//  UserProfileParams.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/7.
//

struct UserProfileParams: RouteParams {
    let userId: String
    let isVIP: Bool
    
    init?(query: [String: Any]) {
        guard let userId = query["userId"] as? String else { return nil }
        self.userId = userId
        self.isVIP = query["isVIP"] as? Bool ?? false
    }
}
