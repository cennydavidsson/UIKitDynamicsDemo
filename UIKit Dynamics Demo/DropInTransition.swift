//
//  Transition.swift
//  UIKit Dynamics Demo
//
//  Created by Cenny Davidsson on 2014-07-31.
//  Copyright (c) 2014 Cenny. All rights reserved.
//

import UIKit

class DropInTransition: NSObject, UIViewControllerAnimatedTransitioning, UIDynamicAnimatorDelegate {
    
    // MARK: Properties
    
    private var transitionContext: UIViewControllerContextTransitioning? = nil
    private var animator: UIDynamicAnimator? = nil
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        
        // Setup transitionContext to use later in delegate method
        self.transitionContext = transitionContext?
        
        // Get view, controllers and frames to work with
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey).view
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromFrame = transitionContext.initialFrameForViewController(fromVC)
        
        // Container view is where the animation takes place so we need to add all view to animate here
        transitionContext.containerView().addSubview(toView)
        
        // Setup the animator
        animator = UIDynamicAnimator(referenceView: transitionContext.containerView())
        animator!.delegate = self
        
        
        // Postion view above screen
        toView.center = CGPoint(x: fromVC.view.center.x, y: -(CGRectGetHeight(fromFrame)/2))
        
        // Setup behaviours
        let gravity = UIGravityBehavior(items: [toView])
        gravity.gravityDirection = CGVectorMake(0, 3)
        let collison = UICollisionBehavior(items: [toView])
        
        let yCoord = CGRectGetMidY(fromVC.view.frame) + CGRectGetHeight(toView.frame)/2
        let startPoint = CGPoint(x: CGRectGetMinX(toView.frame), y: yCoord)
        let endPoint = CGPoint(x: CGRectGetMaxX(toView.frame), y: yCoord)
        collison.addBoundaryWithIdentifier("stop line", fromPoint: startPoint, toPoint: endPoint)
        
        // Add behaviors to animator
        animator!.addBehavior(gravity)
        animator!.addBehavior(collison)
        
    }
    
    // MARK: UIDynamicAnimatorDelegate
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator!) {
        // Remove behaviors and complete transition
        animator!.removeAllBehaviors()
        transitionContext!.completeTransition(true) // IMPORTANT
    }
}
