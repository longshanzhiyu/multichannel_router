//
//  Route.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import UIKit

protocol RouteParams {
    init?(query: [String: Any])
}

protocol RouteInterceptor: AnyObject {
    var identifier: String { get }
    func shouldProceed(path: String, params: RouteParams) async throws -> Bool
}

extension RouteParams {
    func toQuery() -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        var dict = [String: Any]()
        for case let (label?, value) in mirror.children {
            dict[label] = value
        }
        return dict
    }
}

struct Route<Params: RouteParams>: RouteProtocol {
    let path: String
    let transition: TransitionStyle
    private let handler: ((Params) -> UIViewController)?
    
    var paramsType: RouteParams.Type { Params.self }
    
    // 用于需要生成 VC 的路由
    init(
        path: String,
        transition: TransitionStyle,
        handler: @escaping (Params) -> UIViewController
    ) {
        self.path = path
        self.transition = transition
        self.handler = handler
    }
    
    // 用于不需要生成 VC 的路由（如 Tab 切换）
    init(
        path: String,
        transition: TransitionStyle
    ) {
        self.path = path
        self.transition = transition
        self.handler = nil
    }
    
    func createViewController(params: RouteParams) throws -> UIViewController? {
        guard let params = params as? Params else {
            throw RouteError.invalidParams(
                expected: String(describing: Params.self),
                actual: params.toQuery()
            )
        }
        return handler?(params)
    }
}

//struct Route<Params: RouteParams>: RouteProtocol {
//    let path: String
//    let transition: TransitionStyle
//    private let handler: ((Params) -> UIViewController)?
//    
//    var paramsType: RouteParams.Type { Params.self }
//    
//    var requiresViewController: Bool {
//        handler != nil
//    }
//    
//    init(
//        path: String,
//        transition: TransitionStyle,
//        handler: @escaping (Params) -> UIViewController
//    ) {
//        self.path = path
//        self.transition = transition
//        self.handler = handler
//    }
//    
//    func createViewController(params: RouteParams) throws -> UIViewController {
//        guard let params = params as? Params else {
//            throw RouteError.invalidParams(
//                expected: String(describing: Params.self),
//                actual: params.toQuery()
//            )
//        }
//        return handler?(params)
//    }
//}
