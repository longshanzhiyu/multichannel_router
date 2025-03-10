//
//  RouteProtocol.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import UIKit

protocol RouteProtocol {
    var path: String { get }
    var transition: TransitionStyle { get }
    var paramsType: RouteParams.Type { get }
    func createViewController(params: RouteParams) throws -> UIViewController
}
