//
//  FirstViewController.swift
//  UIKit Dynamics Demo
//
//  Created by Cenny Davidsson on 2014-07-24.
//  Copyright (c) 2014 Cenny. All rights reserved.
//

import UIKit
import CoreMotion

class GravityFirstViewController: UIViewController {
    
    //MARK: Properties

    var animator: UIDynamicAnimator!
    var attacthment: UIAttachmentBehavior!
    
    let gravity = UIGravityBehavior()
    let collision = UICollisionBehavior()
    let itemBehavior = UIDynamicItemBehavior()
    
    let CMManager = CMMotionManager()
    
    @IBOutlet weak var gravityLabel: UILabel!
    @IBOutlet weak var elasticityLabel: UILabel!
    @IBOutlet weak var animatorRefView: UIView!
    @IBOutlet weak var gravitySlider: UISlider!
    
    // MARK: UIViewController
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // Instaniate the animator, make sure view is loaded first
        animator = UIDynamicAnimator(referenceView: animatorRefView)
        
        // Make the referenceView's bounds into collisions
        collision.translatesReferenceBoundsIntoBoundary = true

        
        // Add behaviors to the animator
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(itemBehavior)
    }
    
    // MARK: Interaction
    
    @IBAction func changeDeviceGravity(sender: UISwitch) {
        
        gravitySlider.enabled = !sender.on
        
        if sender.on {
            // A function that conforms to CMDeviceMotionHandler and updates gravity
            // based on device orientation
            func gravityUpdated(motion: CMDeviceMotion!, error: NSError!) {
                if error { println("\(error)") }
                
                // Get and apply gravity to behavior
                let motionGravity : CMAcceleration = motion.gravity
                let x = CGFloat(motionGravity.x)
                let y = CGFloat(motionGravity.y)
                gravity.gravityDirection = CGVectorMake(x, -y)
            }
            
            // Completion handler updates UI so it needs to be on main queue
            let mainQueue = NSOperationQueue.mainQueue()
            
            CMManager.startDeviceMotionUpdatesToQueue(mainQueue, withHandler: gravityUpdated)
        } else {
            gravityAngelChanged(gravitySlider)
            
            // Stop updating when we dont need it anymore
            CMManager.stopDeviceMotionUpdates()
        }
    }
    
    @IBAction func gravityAngelChanged(sender: UISlider) {
        gravityLabel.text = "Gravity: \(Int(sender.value))°"
        gravity.angle = CGFloat(sender.value * (Float(M_PI)/180.0))
    }
    
    @IBAction func elasticityChanged(sender: UISlider) {
        elasticityLabel.text =  String(format: "Elasticity: %1.2f", sender.value)
        itemBehavior.elasticity = CGFloat(sender.value)
    }
    
    @IBAction func refresh(sender: AnyObject) {
        for subView in animator.itemsInRect(view.bounds) {
            collision.removeItem(subView as UIView)
            gravity.removeItem(subView as UIView)
            itemBehavior.removeItem(subView as UIView)
            subView.removeFromSuperview()
        }
    }
    
    // MARK: Gestures

    @IBAction func tap(sender: UITapGestureRecognizer) {
        
        // Make a square
        let square = UIImageView(image: UIImage(named: "Box1.png"))
        square.frame.size = CGSize(width: 70, height: 70)
        square.center = sender.locationInView(animatorRefView)
        square.userInteractionEnabled = true    // is false by default in UIImageView
        animatorRefView.addSubview(square)
        
        // Make and add pangesture to the square
        let panGesture = UIPanGestureRecognizer(target: self, action: "panSquare:")
        square.addGestureRecognizer(panGesture)
        
        // Add the square to the behaviors
        gravity.addItem(square)
        collision.addItem(square)
        itemBehavior.addItem(square)
        
    }
    
    func panSquare(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .Began:
            //
            let locationInButton = gesture.locationInView(gesture.view)
            let offset = UIOffset(horizontal: locationInButton.x - CGRectGetWidth(gesture.view.frame)/2,
                                    vertical: locationInButton.y - CGRectGetHeight(gesture.view.frame)/2)
            //
            attacthment = UIAttachmentBehavior(item: gesture.view, offsetFromCenter: offset, attachedToAnchor: gesture.locationInView(animatorRefView))
            animator.addBehavior(attacthment)
        case .Changed:
            //
            attacthment.anchorPoint = gesture.locationInView(animatorRefView)
        default:
            //
            animator.removeBehavior(attacthment)
        }
    }
}
