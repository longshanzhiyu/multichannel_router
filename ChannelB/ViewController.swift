//
//  ViewController.swift
//  ChannelB
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
        
#if ChannelA
        
#endif
    }


}

