//
//  CustomTransitionAnimator.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/7.
//

import UIKit

// 淡入淡出转场动画
class FadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool
    
    init(isPresenting: Bool = true) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        if isPresenting {
            containerView.addSubview(toView)
            toView.alpha = 0.0
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                         delay: 0,
                         options: .curveEaseInOut) {
                toView.alpha = 1.0
                fromView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } completion: { finished in
                fromView.transform = .identity
                transitionContext.completeTransition(finished)
            }
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                         delay: 0,
                         options: .curveEaseInOut) {
                fromView.alpha = 0.0
                toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } completion: { finished in
                toView.transform = .identity
                transitionContext.completeTransition(finished)
            }
        }
    }
}

// 滑动转场动画
class SlideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Direction {
        case left
        case right
        case top
        case bottom
        
        var transform: CGAffineTransform {
            switch self {
            case .left:
                return CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            case .right:
                return CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            case .top:
                return CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
            case .bottom:
                return CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            }
        }
    }
    
    private let direction: Direction
    
    init(direction: Direction = .right) {
        self.direction = direction
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        toView.transform = direction.transform
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                     delay: 0,
                     usingSpringWithDamping: 0.8,
                     initialSpringVelocity: 0.2,
                     options: .curveEaseOut) {
            toView.transform = .identity
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
} 