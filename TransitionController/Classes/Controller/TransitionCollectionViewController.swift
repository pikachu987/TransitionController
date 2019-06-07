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

open class TransitionCollectionViewController: UIViewController, BaseTransition {
    public weak var transitionDelegate: TransitionDelegate? {
        didSet {
            self.transitioningDelegate = self
            self.modalPresentationStyle = .custom
        }
    }
    
    open var key: Any?
    
    public var containerView: UIView? {
        return self.commonTransition.containerView
    }
    
    public var superview: UIView? {
        return self.transitionDelegate?.transitionSuperview
    }
    
    
    open var presentDuration: TimeInterval {
        return 0.35
    }
    
    public var presentFromView: UIView? {
        guard let view = self.transitionDelegate?.transitionPresentFromView(self) else {
            let view = UIView()
            view.frame = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 1, height: 1)
            return view
        }
        return view
    }
    
    public var presentFromImage: UIImage? {
        return self.transitionDelegate?.transitionPresentFromImage(self)
    }
    
    open var presentToView: UIView? {
        return self.view
    }
    
    
    open var dismissDuration: TimeInterval {
        return 0.35
    }
    
    open var dismissFromView: UIView? {
        return self.view
    }
    
    open var dismissFromImage: UIImage? {
        return self.view.imageWithView
    }
    
    public var dismissToView: UIView? {
        guard let view = self.transitionDelegate?.transitionDismissToView(self) else {
            let view = UIView()
            view.frame = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 1, height: 1)
            return view
        }
        return view
    }
    
    open var transitionView: UIView {
        return self.view
    }
    
    open var isGesture: Bool {
        return true
    }
    
    private lazy var commonTransition: CommonTransition = {
        let commonTransition = CommonTransition(baseTransition: self)
        return commonTransition
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(_:)))
        panGestureRecognizer.delegate = self
        self.transitionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    public func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func transitionGesture(_ gesture: UIPanGestureRecognizer, progress: CGFloat) {
        self.transitionDelegate?.transitionGesture(self, viewController: self, gesture: gesture, progress: progress)
    }
    
    public func transitionWillPresent() {
        self.transitionDelegate?.transitionWillPresent(self, viewController: self)
    }
    
    public func transitionDidPresent() {
        self.transitionDelegate?.transitionDidPresent(self, viewController: self)
    }
    
    public func transitionWillDismiss() {
        self.transitionDelegate?.transitionWillDismiss(self, viewController: self)
    }
    
    public func transitionDidDismiss() {
        self.transitionDelegate?.transitionDidDismiss(self, viewController: self)
    }
    
    @objc private func panGesture(_ gesture: UIPanGestureRecognizer) {
        self.commonTransition.panGesture(gesture)
    }
}

// MARK: UIGestureRecognizerDelegate
extension TransitionCollectionViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.isGesture
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension TransitionCollectionViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.commonTransition.presentAnimatedTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.commonTransition.dismissAnimatedTransition
    }
}
