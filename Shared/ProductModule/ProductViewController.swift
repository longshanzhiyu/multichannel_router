//
//  ProductViewController.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import UIKit

final class ProductViewController: UIViewController {
    
    let id: Int?
    let variant: String?
    
    init(id: Int?, variant: String?) {
        self.id = id
        self.variant = variant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
