//
//  Transition.swift
//  UIKit Dynamics Demo
//
//  Created by Cenny Davidsson on 2014-07-31.
//  Copyright (c) 2014 Cenny. All rights reserved.
//

import UIKit

class SwipeInTransition: NSObject, UIViewControllerAnimatedTransitioning, UIDynamicAnimatorDelegate {
    
    // MARK: Properties
    
    private var transitionContext: UIViewControllerContextTransitioning? = nil
    private var animator: UIDynamicAnimator? = nil
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        // Setup transitionContext to use later in delegate method
        self.transitionContext = transitionContext
        
        // Get view, controllers and frames to work with
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let fromFrame = transitionContext.initialFrameForViewController(fromVC)
        
        // Container view is where the animation takes place so we need to add all view to animate here
        transitionContext.containerView().addSubview(toView)
        
        // Setup the animator
        animator = UIDynamicAnimator(referenceView: transitionContext.containerView())
        animator!.delegate = self
        
        
        // Postion view to the side of the screen
        toView.center = CGPoint(x: (CGRectGetWidth(fromFrame)) + CGRectGetWidth(toView.frame)/2, y: CGRectGetMidY(fromFrame))
        
        // Setup behaviors
        let snap = UISnapBehavior(item: toView, snapToPoint: fromVC.view.center)
        snap.damping = 0.25
        
        let itemBehavior = UIDynamicItemBehavior(items: [toView])
        itemBehavior.allowsRotation = false
        
        // Add behaviors to animator
        animator!.addBehavior(snap)
        animator!.addBehavior(itemBehavior)
        
    }
    
    // MARK: UIDynamicAnimatorDelegate
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator!) {
        
        // Remove behaviors and complete transition
        animator!.removeAllBehaviors()
        transitionContext!.completeTransition(true) // IMPORTANT
    }
}
