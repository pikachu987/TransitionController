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

protocol AnimatedTransitionDelegate: class {
    var baseTransition: BaseTransition { get set }
}

class AnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    weak var delegate: AnimatedTransitionDelegate?
    
    var mode: Mode = .present
    weak var containerView: UIView?
    var conextView: UIView?
    var imageView: UIImageView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if self.mode == .present {
            return self.delegate?.baseTransition.presentDuration ?? 0.35
        } else {
            return self.delegate?.baseTransition.dismissDuration ?? 0.35
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let superview = self.delegate?.baseTransition.superview else { return }
        guard let viewController = transitionContext.viewController(forKey: self.mode == .present ? .to : .from) else { return }
        
        viewController.view.layoutIfNeeded()
        let containerView = transitionContext.containerView
        self.containerView = containerView
        
        if self.conextView == nil {
            let conextView = UIView()
            conextView.translatesAutoresizingMaskIntoConstraints = false
            conextView.alpha = 0
            conextView.backgroundColor = self.delegate?.baseTransition.transitionView.backgroundColor
            containerView.addSubview(conextView)
            containerView.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": conextView])
            )
            containerView.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": conextView])
            )
            self.conextView = conextView
            
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            containerView.addSubview(imageView)
            self.imageView = imageView
        }
        
        if self.mode == .present {
            let presentDuration = self.delegate?.baseTransition.presentDuration ?? 0.35
            self.delegate?.baseTransition.transitionWillPresent()
            
            self.imageView?.image = (self.delegate?.baseTransition.presentFromImage ?? self.delegate?.baseTransition.presentToView?.imageWithView)
            if let fromView = self.delegate?.baseTransition.presentFromView {
                self.imageView?.layer.cornerRadius = fromView.layer.cornerRadius
                self.imageView?.frame = fromView.convert(fromView.bounds, to: superview)
                self.imageView?.contentMode = fromView.contentMode
            }
            UIView.animate(withDuration: presentDuration, animations: {
                self.conextView?.alpha = 1
                if let toView = self.delegate?.baseTransition.presentToView {
                    self.imageView?.frame = toView.frame
                    self.imageView?.layer.cornerRadius = toView.layer.cornerRadius
                }
            }, completion: { _ in
                self.imageView?.backgroundColor = nil
                self.imageView?.image = nil
                containerView.addSubview(viewController.view)
                transitionContext.completeTransition(true)
                self.delegate?.baseTransition.transitionDidPresent()
            })
            
        } else if self.mode == .dismiss {
            let dismissDuration = self.delegate?.baseTransition.dismissDuration ?? 0.35
            viewController.view.removeFromSuperview()
            self.delegate?.baseTransition.transitionWillDismiss()
            
            self.imageView?.image = self.delegate?.baseTransition.dismissFromImage
            if let fromView = self.delegate?.baseTransition.dismissFromView {
                self.imageView?.frame = fromView.convert(fromView.bounds, to: containerView)
                self.imageView?.layer.cornerRadius = fromView.layer.cornerRadius
            }
            
            UIView.animate(withDuration: dismissDuration, animations: {
                self.conextView?.alpha = 0
                if let toView = self.delegate?.baseTransition.dismissToView {
                    self.imageView?.frame = toView.convert(toView.bounds, to: superview)
                    self.imageView?.layer.cornerRadius = toView.layer.cornerRadius
                    self.imageView?.contentMode = toView.contentMode
                }
            }, completion: { _ in
                self.imageView?.image = nil
                transitionContext.completeTransition(true)
                self.delegate?.baseTransition.transitionDidDismiss()
            })
        }
    }
}

// MARK: AnimatedTransition + Mode
extension AnimatedTransition {
    enum Mode {
        case present
        case dismiss
    }
}
