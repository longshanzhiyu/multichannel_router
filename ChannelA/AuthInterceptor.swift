//
//  AuthInterceptor.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import UIKit

class AuthInterceptor: RouteInterceptor {
    let identifier = "auth_check"
    
    func shouldProceed(path: String, params: RouteParams) -> Bool {
//        let alert = await UIAlertController.init(title: "Alert", message: "haven't login", preferredStyle: .alert)
//        await UIApplication.shared.topViewController?.present(alert, animated: true)
        return true
    }
}
