//
//  ViewController.swift
//  ChannelA
//
//  Created by iReader on 2025/3/4.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.title = "Home"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Home"
        
        let m1 = ComMoudle1()
        m1.introduce()
        
        
        if let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String {
            print("API Base URL: \(apiBaseURL)")
        }
    }

    @IBAction func goNextPage(_ sender: UIButton) {
        Task { @MainActor in
            
            
            
//            await openSettings()
//            return
            
            guard let params = UserProfileParams(query: [
                "userId": "123",
                "isVIP": true
            ]) else { return  }
//            
//            // 示例 URL: myapp://products/detail?id=123&variant=pro
//            let url = URL(string: "myapp://www.longshanzhiyu.com/tab/profile?id=123&variant=pro")!
//            await DeepLinkHandler.handle(url: url)
            
            try await Router.navigate("/user/profile", params: params, interceptors: [AuthInterceptor()])
        }
    }
    
    func openSettings() async {
        guard let params = SettingsParams(query: [
            "section": "privacy",
            "requiresAuth": true
        ]) else { return }
        
        let authInterceptor = AuthInterceptor()
        
        do {
            try await Router.navigate(
                "/app/settings",
                params: params,
                interceptors: [authInterceptor]
            )
        } catch let error as RouteError {
//            handlePresentError(error)
        } catch {
            print("Unknown error: \(error)")
        }
    }
    
}

