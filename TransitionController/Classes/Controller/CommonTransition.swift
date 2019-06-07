//Copyright (c) 2019 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit

class CommonTransition: NSObject, AnimatedTransitionDelegate {
    var baseTransition: BaseTransition
    
    private let animatedTransition = AnimatedTransition()
    private var centerPoint = CGPoint.zero
    
    var containerView: UIView? {
        return self.animatedTransition.containerView
    }
    
    var presentAnimatedTransition: AnimatedTransition {
        self.animatedTransition.mode = .present
        return self.animatedTransition
    }
    
    var dismissAnimatedTransition: AnimatedTransition {
        self.animatedTransition.mode = .dismiss
        return self.animatedTransition
    }
    
    init(baseTransition: BaseTransition) {
        self.baseTransition = baseTransition
        super.init()
        self.animatedTransition.delegate = self
    }
    
    func panGesture(_ gesture: UIPanGestureRecognizer) {
        let view = self.baseTransition.transitionView
        
        var gestureProgress: CGFloat {
            let origin = self.centerPoint
            let changeX = abs(view.center.x - origin.x)
            let changeY = abs(view.center.y - origin.y)
            let progressX = changeX / view.bounds.width
            let progressY = changeY / view.bounds.height
            return max(progressX, progressY)
        }
        
        self.baseTransition.transitionGesture(gesture, progress: gesture.state == .began ? 0 : gestureProgress)
        switch gesture.state {
        case .began:
            self.centerPoint = view.center
        case .changed:
            let origin = view.center
            let change = gesture.translation(in: view)
            self.baseTransition.transitionView.center = CGPoint(x: origin.x + change.x, y: origin.y + change.y)
            let alpha = 1 - gestureProgress
            self.animatedTransition.conextView?.alpha = alpha
            gesture.setTranslation(CGPoint.zero, in: nil)
        case .ended:
            let velocity = gesture.velocity(in: view)
            if gestureProgress > 0.25 || sqrt(velocity.x*velocity.x + velocity.y*velocity.y) > 1000 {
                self.baseTransition.dismiss()
            } else {
                fallthrough
            }
        default:
            UIView.animate(withDuration: 0.3, animations: {
                self.baseTransition.transitionView.center = self.centerPoint
            }, completion: { _ in
                self.centerPoint = .zero
                self.animatedTransition.conextView?.alpha = 1
            })
        }
    }
}
