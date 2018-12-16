//
//  ViewController.swift
//  Gesture Recogniser
//
//  Created by Prashant G on 12/3/18.
//  Copyright © 2018 MyOrg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func handlePan(_ recogniser: UIPanGestureRecognizer) {
        
        guard let recogniserView = recogniser.view else {
            return
        }
        
        let translation = recogniser.translation(in: view)
        recogniserView.center.x += translation.x
        recogniserView.center.y += translation.y
        recogniser.setTranslation(.zero, in: view)
        
        guard recogniser.state == .ended else {
            return
        }
        
        let velocity = recogniser.velocity(in: view)
        let velocityToFinalPoint = CGPoint(x: velocity.x / 15, y: velocity.y / 15)
        //let bounds = UIEdgeInsetsEqualToEdgeInsets(view.bounds,view.safeAreaInsets)
        let bounds = view.bounds.inset(by: view.safeAreaInsets)
        var finalPoint = recogniserView.center
        finalPoint.x += velocityToFinalPoint.x
        finalPoint.y += velocityToFinalPoint.y
        finalPoint.x =  min(max(finalPoint.x, bounds.minX), bounds.maxX)
        finalPoint.y =  min(max(finalPoint.y, bounds.minY), bounds.maxY)
        
        let vectorToFinalPointLength = (
            velocityToFinalPoint.x * velocityToFinalPoint.x
                + velocityToFinalPoint.y * velocityToFinalPoint.y
            ).squareRoot()
        
        UIView.animate(withDuration: TimeInterval(vectorToFinalPointLength / 1800),
                       delay: 0, options: .curveEaseOut, animations: {
                        recogniserView.center = finalPoint
        }, completion:nil)
    }

    
    @IBAction func handlePinch(_ recogniser: UIPinchGestureRecognizer) {
        guard let recogniserView = recogniser.view else {
            return
        }
        
        recogniserView.transform = recogniserView.transform.scaledBy(x: recogniser.scale, y: recogniser.scale)
        recogniser.scale = 1
    }
    
    @IBAction func handleRotate(_ recogniser: UIRotationGestureRecognizer) {
        guard let recogniserView = recogniser.view else {
            return
        }
        
        recogniserView.transform = recogniserView.transform.rotated(by: recogniser.rotation)
        recogniser.rotation = 0
    }
    
}

extension ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
