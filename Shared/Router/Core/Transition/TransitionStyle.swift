//
//  TransitionStyle.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/10.
//

import UIKit

// MARK: - 路由类型
enum TransitionStyle {
    case push(animated: Bool)
    case present(
        animated: Bool,
        style: UIModalPresentationStyle = .fullScreen, // 默认全屏
        completion: (() -> Void)? = nil
    )
    case pop(animated: Bool)
    case switchTab(index: Int)  // 新增 Tab 切换类型
    case switchTabByIdentifier(String) // 按标识符切换
    case setRoot(animated: Bool)
}
