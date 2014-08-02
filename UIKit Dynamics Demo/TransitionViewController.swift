//
//  TransitionViewController.swift
//  UIKit Dynamics Demo
//
//  Created by Cenny Davidsson on 2014-07-30.
//  Copyright (c) 2014 Cenny. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    enum TransitionCase {
        case None
        case Drop
        case Swipe
        case Swing
    }
    
    var transition: TransitionCase!
    
    @IBAction func unwindToTransitionVC(segue: UIStoryboardSegue) {
        // FIXME: Temporary fix for unwindSegue, in beta 4
        dismissViewControllerAnimated(true, completion: {})
    }
    
    // MARK: UIViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        super.prepareForSegue(segue, sender: sender)

        let toVC: UIViewController = segue.destinationViewController as UIViewController
        toVC.modalPresentationStyle = .Custom
        toVC.transitioningDelegate = self
        
        switch segue.identifier! {
        case "drop":
            transition = .Drop
        case "swipe":
            transition = .Swipe
        case "swing":
            transition = .Swing
        default:
            toVC.modalPresentationStyle = .FormSheet
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        
        switch transition! {
        case .Drop:
            return DropInTransition()
        case .Swipe:
            return SwipeInTransition()
        case .Swing:
            return SwingInTransition()
        default:
            return DropInTransition()
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        return PushOffTransition()
    }
    
}
