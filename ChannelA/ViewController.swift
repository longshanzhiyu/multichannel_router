//
//  ViewController.swift
//  ChannelA
//
//  Created by iReader on 2025/3/4.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let m1 = ComMoudle1()
        m1.introduce()
        
        if let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String {
            print("API Base URL: \(apiBaseURL)")
        }
    }

    @IBAction func goNextPage(_ sender: UIButton) {
        Task { @MainActor in
            guard let params = UserProfileParams(query: [
                "userId": "123",
                "isVIP": true
            ]) else { return  }
            
            try await Router.navigate("/user/profile", params: params)
        }
    }
    
}

