//
//  My.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/5.
//

import SnapKit
import UIKit

class MyView: UIViewController {
    var globalConfig: GlobalConfig?
    var headerview = UIView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(headerview)
        
        headerview.snp.makeConstraints { make in
#if CHANNEL_A
            make.top.equalTo(13)
#elseif CHANNEL_B
            make.top.equalTo(16)
#endif
        }

    }
    
}
