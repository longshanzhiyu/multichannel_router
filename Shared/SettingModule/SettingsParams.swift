//
//  SettingsParams.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

struct SettingsParams: RouteParams {
    let section: String
    let requiresAuth: Bool
    
    init?(query: [String: Any]) {
        guard let section = query["section"] as? String else { return nil }
        self.section = section
        self.requiresAuth = query["requiresAuth"] as? Bool ?? false
    }
}
