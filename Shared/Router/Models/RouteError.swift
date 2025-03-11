//
//  RouteError.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import Foundation

// MARK: - 错误类型
enum RouteError: Error, LocalizedError {
    case unregisteredRoute(path: String)
    case invalidParams(expected: String, actual: [String: Any])
    case intercepted(interceptorID: String)
    case transitionFailed(description: String)
    case invalidTabIndex(max: Int)
    case tabNotFound(identifier: String)
    
    var errorDescription: String? {
        switch self {
        case .unregisteredRoute(let path):
            return "Route not registered: \(path)"
        case .invalidParams(let expected, let actual):
            return "Invalid params. Expected \(expected), got \(actual)"
        case .intercepted(let id):
            return "Route intercepted by: \(id)"
        case .transitionFailed(let desc):
            return "Transition failed: \(desc)"
        case .invalidTabIndex(let max):
            return "invalid tab index: \(max)"
        case .tabNotFound(let identifier):
            return "tab \(identifier) not found"
        }
    }
}

extension RouteError {
    func getInterceptor<T: RouteInterceptor>(ofType type: T.Type) -> T? {
        guard case .intercepted(let interceptor) = self else { return nil }
        return interceptor as? T
    }
}


