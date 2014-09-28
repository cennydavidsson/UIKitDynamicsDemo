//
//  SecondViewController.swift
//  UIKit Dynamics Demo
//
//  Created by Cenny Davidsson on 2014-07-24.
//  Copyright (c) 2014 Cenny. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: Properties
    
    var animator: UIDynamicAnimator!
    var attachtment: UIAttachmentBehavior!
    let collision = UICollisionBehavior()
    let gravity = UIGravityBehavior()
    
    var buttonOrgin: CGPoint!
    
    // MARK: UIViewController
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // Setup behaviors and animator
        collision.translatesReferenceBoundsIntoBoundary = true
        animator = UIDynamicAnimator(referenceView: view) // must be done when view is loaded and setup
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }
    
    // MARK: Button interaction
    
    @IBAction func addAttachment(sender: UIButton, forEvent event: UIEvent) {
        
        // Get orgin if touchUpOutside occurs
        buttonOrgin = sender.center
        
        // Get location of tuch in button
        let touch = event.allTouches()!.anyObject() as UITouch
        let locationInButton = touch.locationInView(sender)
        let offset = UIOffset(horizontal: locationInButton.x - CGRectGetWidth(sender.frame)/2,
                                vertical: locationInButton.y - CGRectGetHeight(sender.frame)/2)
        
        // Anchor button to touch
        attachtment = UIAttachmentBehavior(item: sender, offsetFromCenter: offset, attachedToAnchor: touch.locationInView(view))
        
        // Add behaviors
        animator.addBehavior(attachtment)
        gravity.addItem(sender)
        collision.addItem(sender)
        
    }
    
    @IBAction func touchUpInside(sender: AnyObject) {

        // Remove behavor that holds the button hanging
        animator.removeBehavior(attachtment)
    }
    
    @IBAction func touchUpOutside(sender: AnyObject) {
        
        // Remove behavior and items
        animator.removeBehavior(attachtment)
        gravity.removeItem(sender as UIView)
        collision.removeItem(sender as UIView)
        
        // Make a snap to its orginal center
        let snap = UISnapBehavior(item: sender as UIView, snapToPoint: buttonOrgin)
        animator.addBehavior(snap)
        
        // Remove behavior when snap is done
        snap.action = { [unowned self, unowned snap] in // FIXME: Unsure if this is the best solution
            if CGPointEqualToPoint(self.buttonOrgin, sender.center) { self.animator.removeBehavior(snap) }
        }
    }
}

