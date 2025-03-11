//
//  UserProfileViewController.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/7.
//

import UIKit

class UserProfileViewController: UIViewController, TabIdentifiable {
    let tabIdentifier: String = "profile"
    
    let userId: String
    let isVIP: Bool
    
    init(userId: String, isVIP: Bool) {
        self.userId = userId
        self.isVIP = isVIP
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        let button = UIButton(type: .custom)
        button.setTitle("go to profile", for: .normal)
        button.frame = CGRectMake(100, 300, 100, 30)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    
    @objc func click() {
        Task { @MainActor in
            guard let params = EmptyParams(query: [:]) else {
                return
            }
            try await Router.navigate(
                "/tab/profile",
                params: params,
                interceptors: []
            )
        }
//        guard let params = EmptyParams(query: [:]) else {
//            return
//        }
//        
//        do {
//            try await Router.navigate(
//                "/tab/profile",
//                params: params,
//                interceptors: []
//            )
//        } catch let error as RouteError {
////            handlePresentError(error)
//        } catch {
//            print("Unknown error: \(error)")
//        }
    }
    
}
