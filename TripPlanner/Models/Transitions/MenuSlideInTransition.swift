//
//  MenuSlideInTransition.swift
//  TripPlanner
//
//  Created by Hamster on 1/28/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

/*
 MenuSlideInTransition
 Transition class for presenting a VC over the current context
 */

import UIKit

class MenuSlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    let dimmingView = UIView()
    
    // MARK: Instance methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to)
            else {return}
        guard let fromViewController = transitionContext.viewController(forKey: .from)
            else {return}
        
        // Asking the transition for a containerView
        let containerView = transitionContext.containerView
        
        // Setting the presentation bounds
        let presentWidth = toViewController.view.bounds.width * 0.85
        let presentHeight = toViewController.view.bounds.height
        
        if isPresenting {
            // Add dimming effect to view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            
            // Add menu viewcontroller to container view
            containerView.addSubview(toViewController.view)
            
            // Init frame off the screen
            toViewController.view.frame = CGRect(x: -presentWidth, y: 0,
                                                 width: presentWidth,
                                                 height: presentHeight)
        }
        
        // Closure for transforming view on screen
        let transformOnScreen = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: presentWidth, y: 0)
        }
        
        // Closure for transforming view off screen
        let transformOffScreen = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }
        
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        
        UIView.animate(withDuration: duration, animations:
            {self.isPresenting ? transformOnScreen() : transformOffScreen()},
            completion:
            {(_) in transitionContext.completeTransition(!isCancelled)}
        )
    }
}
