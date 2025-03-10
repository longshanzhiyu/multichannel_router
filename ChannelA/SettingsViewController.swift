//
//  SettingViewController.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import UIKit

final class SettingsViewController: UIViewController {
    let selectedSection: String?
    let requiresAuthentication: Bool?
    
    init(selectedSection: String?, requiresAuthentication: Bool?) {
        self.selectedSection = selectedSection
        self.requiresAuthentication = requiresAuthentication
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: DispatchWorkItem(block: {
            
        }))
    }
}
