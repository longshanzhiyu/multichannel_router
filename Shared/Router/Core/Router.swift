//
//  Router.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import Foundation
import UIKit

// MARK: - 路由管理器
final class Router {
    private static var routes: [String: any RouteProtocol] = [:]
    private static let queue = DispatchQueue(label: "com.router.queue", attributes: .concurrent)
    
    // 注册路由
    static func register<Params: RouteParams>(_ route: Route<Params>) {
        queue.async(flags: .barrier) {
            routes[route.path] = route
        }
    }
    
    static func getRoute(for path: String) -> RouteProtocol? {
        routes[path]
    }
    
    // 执行跳转
    @MainActor
    static func navigate(
        _ path: String,
        params: RouteParams,
        interceptors: [RouteInterceptor] = []
    ) async throws {
        guard let route = getRoute(for: path) else {
            throw RouteError.unregisteredRoute(path: path)
        }
        
        // 参数校验
        guard type(of: params) == route.paramsType else {
            throw RouteError.invalidParams(
                expected: String(describing: route.paramsType),
                actual: params.toQuery()
            )
        }
        
        // 拦截器检查
        for interceptor in interceptors {
            guard try await interceptor.shouldProceed(path: path, params: params) else {
                throw RouteError.intercepted(interceptorID: interceptor.identifier)
            }
        }
        
        // 执行跳转
        do {
            let targetVC = try route.createViewController(params: params)
            try performTransition(route.transition, target: targetVC)
        } catch {
            throw RouteError.transitionFailed(description: error.localizedDescription)
        }
    }
    
    // 私有方法
//    static func getRoute(for path: String) async -> (any RouteProtocol)? {
//        await queue.sync {
//            routes[path]
//        }
//    }
    
    @MainActor
    private static func performTransition(_ style: TransitionStyle, target: UIViewController) throws {
        guard let topVC = UIApplication.shared.topViewController else {
            throw RouteError.transitionFailed(description: "No top view controller")
        }
        
        switch style {
        case .push(let animated):
            guard let nav = topVC.navigationController else {
                throw RouteError.transitionFailed(description: "Missing navigation controller")
            }
            nav.pushViewController(target, animated: animated)
            
        case .present(let animated, let style, let completion):
                target.modalPresentationStyle = style // 关键设置
                topVC.present(target, animated: animated, completion: completion)
            
        case .pop(let animated):
            topVC.navigationController?.popViewController(animated: animated)
        }
    }
}


extension Router {
    static func debugPrintRoutes() {
        queue.sync {
            routes.keys.forEach { print("Registered Route: \($0)") }
        }
    }
    
    static func validateAllRoutes() -> [String] {
        queue.sync {
            routes.compactMap { path, _ in
                URL(string: path) == nil ? path : nil
            }
        }
    }
}
