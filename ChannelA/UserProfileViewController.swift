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
    }
    
    
}
