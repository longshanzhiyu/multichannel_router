//
//  ProfileController.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/11.
//

import UIKit

class ProfileController: UIViewController, TabIdentifiable {
    let tabIdentifier: String = "profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
    }
}
