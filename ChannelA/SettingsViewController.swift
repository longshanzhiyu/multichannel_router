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
        
        let button = UIButton()
        button.setTitle("back", for: .normal)
        view.addSubview(button)
        button.frame = CGRectMake(100, 300, 80, 30)
        button.addTarget(self, action: #selector(goback), for: .touchUpInside)
        
    }
    
    @objc func goback() {
        
        Task { @MainActor in
            await gobackProfile()
        }
    }
    
    func gobackProfile() async {
        guard let params = EmptyParams(query: [:]) else { return }
        
        do {
            try await Router.navigate("/tab/profile", params: params)
        } catch let error as RouteError {
//            handlePresentError(error)
            print(error.localizedDescription)
        } catch {
            print("Unknown error: \(error)")
        }
    }
    
}
