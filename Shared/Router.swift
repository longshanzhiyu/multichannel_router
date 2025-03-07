//
//  Router.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/7.
//

import UIKit
import Foundation

// 路由协议定义
protocol RouteType {
    var path: String { get }
    var transition: TransitionStyle { get }
}

// 跳转类型枚举
enum TransitionStyle {
    case push(animated: Bool)
    case present(animated: Bool, completion: (() -> Void)?)
    case pop(animated: Bool)
}

// 路由参数协议
protocol RouteParams {
    init?(query: [String: Any])
}

// 高级路由系统
struct Route<Params: RouteParams> {
    let path: String
    let transition: TransitionStyle
    let handler: (Params) -> UIViewController
}

// 拦截器协议
protocol RouteInterceptor {
    func shouldProceed(path: String, params: RouteParams) async throws -> Bool
}

// 路由管理器
final class Router {
    private static var routes: [String: Any] = [:]
    private static let queue = DispatchQueue(label: "com.router.syncQueue", attributes: .concurrent)
    
    // 类型安全注册
    static func register<Params: RouteParams>(_ route: Route<Params>) {
        queue.async(flags: .barrier) {
            routes[route.path] = route
        }
    }
    
    // 带拦截器的跳转
    static func navigate<Params: RouteParams>(
        _ path: String,
        params: Params,
        interceptors: [RouteInterceptor] = [],
        from: UIViewController? = nil,
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) async {
        do {
            guard let route = await getRoute(for: path) as? Route<Params> else {
                throw RouteError.unregisteredRoute
            }
            
            // 执行拦截器链
            for interceptor in interceptors {
                guard try await interceptor.shouldProceed(path: path, params: params) else {
                    throw RouteError.intercepted(interceptor: interceptor)
                }
            }
            
            await MainActor.run {
                let targetVC = route.handler(params)
                performTransition(route.transition, target: targetVC, from: from) { result in
                    completion?(result)
                }
            }
        } catch {
            completion?(.failure(error))
        }
    }
    
    // 线程安全的转场执行
    @MainActor
    private static func performTransition(
        _ style: TransitionStyle,
        target: UIViewController,
        from: UIViewController?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let sourceVC = from ?? UIApplication.shared.topViewController else {
            completion(.failure(RouteError.sourceViewControllerNotFound))
            return
        }
        
        switch style {
        case .push(let animated):
            // 如果没有导航控制器，自动创建一个
            if sourceVC.navigationController == nil {
                let nav = UINavigationController(rootViewController: target)
                sourceVC.present(nav, animated: animated) {
                    completion(.success(()))
                }
            } else {
                sourceVC.navigationController?.pushViewController(target, animated: animated)
                completion(.success(()))
            }
            
        case .present(let animated, let presentCompletion):
            // 确保目标控制器有导航控制器
            if !(target is UINavigationController) {
                let nav = UINavigationController(rootViewController: target)
                sourceVC.present(nav, animated: animated) {
                    presentCompletion?()
                    completion(.success(()))
                }
            } else {
                sourceVC.present(target, animated: animated) {
                    presentCompletion?()
                    completion(.success(()))
                }
            }
            
        case .pop(let animated):
            if let nav = sourceVC.navigationController {
                nav.popViewController(animated: animated)
                completion(.success(()))
            } else {
                sourceVC.dismiss(animated: animated) {
                    completion(.success(()))
                }
            }
        }
    }
    
    private static func getRoute(for path: String) async -> Any? {
        await queue.sync {
            routes[path]
        }
    }
    
//    // 执行路由跳转
//    static func navigate(
//        _ route: RouteType,
//        params: RouteParams? = nil,
//        from: UIViewController? = nil
//    ) throws {
//        guard let handler = routes[route.path] as? (RouteParams) -> UIViewController else {
//            throw RouteError.unregisteredRoute
//        }
//        
//        weak var sourceVC = from
//        do {
//            sourceVC = try UIApplication.shared.safeTopViewController()
//        }
//        catch {
//            print("获取失败：\(error.localizedDescription)")
//        }
//        
//        guard sourceVC?.viewIfLoaded?.window != nil else {
//            print("页面打开失败: \(String(describing: sourceVC.self))")
//            return
//        }
//        
//        let targetVC = handler(params ?? EmptyParams())
//        
//        switch route.transition {
//        case .push(let animated):
//            sourceVC?.navigationController?.pushViewController(targetVC, animated: animated)
//        case .present(let animated, let completion):
//            let nav = UINavigationController(rootViewController: targetVC)
//            sourceVC?.present(nav, animated: animated, completion: completion)
//        case .pop(let animated):
//            sourceVC?.navigationController?.popViewController(animated: animated)
//        }
//        
//    }
    

    // 拦截器协议（增加身份标识）
    protocol RouteInterceptor: AnyObject {  // 使用 class-only 协议
        var identifier: String { get }      // 拦截器唯一标识
        func shouldProceed(path: String, params: RouteParams) async throws -> Bool
    }
    
    enum RouteError: Error {
        case intercepted(interceptor: RouteInterceptor)
        case unregisteredRoute
        case invalidParams
        case viewControllerNotFound
        case sourceViewControllerNotFound
        
        var localizedDescription: String {
            switch self {
            case .intercepted(let interceptor):
                return "Route was intercepted by \(interceptor.identifier)"
            case .unregisteredRoute:
                return "Attempting to navigate to an unregistered route"
            case .invalidParams:
                return "Invalid parameters provided for route"
            case .viewControllerNotFound:
                return "Target view controller could not be created"
            case .sourceViewControllerNotFound:
                return "Source view controller could not be found"
            }
        }
    }
    
    struct EmptyParams: RouteParams {
        init() {}
        init?(query: [String: Any]) { nil }
    }
}

