//
//  Router.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import Foundation
import UIKit

// Tab 标识协议
protocol TabIdentifiable {
    var tabIdentifier: String { get }
}

// MARK: - 路由管理器
final class Router {
    private static var routes: [String: any RouteProtocol] = [:]
    private static let queue = DispatchQueue(label: "com.router.queue", attributes: .concurrent)
    
    // 添加 Tab 控制器引用（需提前注册）
    static weak var tabBarController: UITabBarController?
    
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
            guard let targetVC = try route.createViewController(params: params) else {
                throw RouteError.unregisteredRoute(path: "")
            }
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
            
        case .switchTab(let index):
            try switchTab(index: index)
            
        case .switchTabByIdentifier(let id):
            try switchTab(identifier: id)
            if ((self.rootViewController?.presentedViewController) != nil) {
                self.rootViewController?.dismiss(animated: true)
            }
        
        case .setRoot(let animated):
            guard let rootVc = UIApplication.shared.rootViewController else {
                throw RouteError.transitionFailed(description: "Missing root controller")
            }
            if let nav = rootVc as? UINavigationController {
                var vcs = nav.viewControllers
                vcs.insert(rootVc, at: 0)
                nav.viewControllers = vcs
                nav.popToRootViewController(animated: animated)
            }
            else {
                
            }
        }
    }
    
    // Tab 切换实现
    @MainActor
    private static func switchTab(index: Int) throws {
        guard self.rootViewController != nil else {
            throw RouteError.transitionFailed(description: "Router has no a root vc")
        }
        
        if let tabVc = rootViewController as? UITabBarController {
            self.tabBarController = tabVc
        }
        
        if let tabVc = rootViewController as? UINavigationController {
            guard let vc = tabVc.viewControllers.first as? UITabBarController else {
                throw RouteError.transitionFailed(description: "Tab controller not registered")
            }
            self.tabBarController = vc
        }
        
        guard let tabBarController = self.tabBarController else {
            throw RouteError.transitionFailed(description: "Tab controller not registered")
        }
        
        guard index >= 0 && index < tabBarController.viewControllers?.count ?? 0 else {
            throw RouteError.invalidTabIndex(max: tabBarController.viewControllers?.count ?? 0 - 1)
        }
        
        tabBarController.selectedIndex = index
        // 重置导航栈（可选）
        if let nav = tabBarController.selectedViewController as? UINavigationController {
            nav.popToRootViewController(animated: false)
        }
    }
    
    @MainActor
    private static func switchTab(identifier: String) throws {
        
        guard self.rootViewController != nil else {
            throw RouteError.transitionFailed(description: "Router has no a root vc")
        }
        
        if let tabVc = rootViewController as? UITabBarController {
            self.tabBarController = tabVc
        }
        
        if let tabVc = rootViewController as? UINavigationController {
            guard let vc = tabVc.viewControllers.first as? UITabBarController else {
                throw RouteError.transitionFailed(description: "Tab controller not registered")
            }
            self.tabBarController = vc
        }
        
        guard let tabBarController = self.tabBarController else {
            throw RouteError.transitionFailed(description: "Tab controller not registered")
        }
        
        guard let viewControllers = tabBarController.viewControllers else {
            throw RouteError.tabNotFound(identifier: identifier)
        }
        
        for (index, vc) in viewControllers.enumerated() {
            let tabVC = (vc as? UINavigationController)?.viewControllers.first ?? vc
            if let identifiable = tabVC as? TabIdentifiable,
               identifiable.tabIdentifier == identifier {
                tabBarController.selectedIndex = index
                return
            }
        }
        
        throw RouteError.tabNotFound(identifier: identifier)
    }
}


extension Router {
    static var rootViewController: UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.rootViewController
        }
        return nil
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
