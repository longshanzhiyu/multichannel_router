//
//  URLParser.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import Foundation

struct URLParser {
    static func parse(_ url: URL) -> (path: String, params: [String: Any]) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let path = components?.path ?? ""
        var params: [String: Any] = [:]
        components?.queryItems?.forEach { item in
            params[item.name] = item.value
        }
        return (path, params)
    }
}
