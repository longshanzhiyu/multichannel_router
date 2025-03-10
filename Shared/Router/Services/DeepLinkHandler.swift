//
//  DeepLinkHandler.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import Foundation

// MARK: - 深度链接处理
struct DeepLinkHandler {
    static func handle(url: URL) async {
        let (path, query) = URLParser.parse(url)
        
        do {
            guard let route = Router.getRoute(for: path) else {
                throw RouteError.unregisteredRoute(path: path)
            }
            
            guard let params = route.paramsType.init(query: query) else {
                throw RouteError.invalidParams(
                    expected: String(describing: route.paramsType),
                    actual: query
                )
            }
            
            try await Router.navigate(path, params: params)
        } catch {
            handleRouteError(error, path: path, query: query)
        }
    }
    
    private static func handleRouteError(_ error: Error, path: String, query: [String: Any]) {
        if let routeError = error as? RouteError {
            switch routeError {
            case .invalidParams:
                print("参数解析失败: \(query)")
            default:
                break
            }
        }
    }
}
