//
//  ProductParams.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

struct ProductParams: RouteParams {
    let productId: Int
    let variant: String?
    
    init?(query: [String: Any]) {
        guard let id = Int(query["id"] as! String) else {
            return nil
        }
        self.productId = id
        self.variant = query["variant"] as? String
    }
}
