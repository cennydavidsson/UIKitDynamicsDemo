//
//  Transition.swift
//  UIKit Dynamics Demo
//
//  Created by Cenny Davidsson on 2014-07-31.
//  Copyright (c) 2014 Cenny. All rights reserved.
//

import UIKit

class PushOffTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Get view, controllers and frames to work with
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromFrame = transitionContext.initialFrameForViewController(fromVC!)
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        // Setup the animator
        let animator = UIDynamicAnimator(referenceView: transitionContext.containerView())
        
        // Setup behaviors
        let gravity = UIGravityBehavior(items: [fromView])
        gravity.gravityDirection = CGVectorMake(0, 3)
        
        let push = UIPushBehavior(items: [fromView], mode: .Instantaneous)
        push.pushDirection = CGVectorMake(0, -20)
        // FIXME: make offset dynamic to view
        let randomHrizontal = CGFloat((arc4random() % 26) - 10)
        let offset = UIOffset(horizontal: randomHrizontal, vertical: CGRectGetHeight(fromFrame)/2)
        push.setTargetOffsetFromCenter(offset, forItem: fromView)
        
        // When view is off screen complete transition and remove behaviors
        push.action = {
            if !CGRectIntersectsRect(transitionContext.containerView().frame, fromView.frame) {
                animator.removeAllBehaviors()
                transitionContext.completeTransition(true) // IMPORTANT
             }
        }
        
        // Add behaviors
        animator.addBehavior(gravity)
        animator.addBehavior(push)
    }
}