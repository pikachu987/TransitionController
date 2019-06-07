//
//  ImageViewController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import TransitionController

class ImageViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var colorSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.cornerRadius = self.imageView.frame.width/2
    }
    
    @IBAction private func transitionTap(_ sender: UIButton) {
        guard let viewController = UIStoryboard(name: "Image", bundle: nil).instantiateViewController(withIdentifier: "ImageTransitionController") as? ImageTransitionController else { return }
        viewController.transitionDelegate = self
        viewController.image = self.imageView.image
        viewController.view.backgroundColor = self.colorSwitch.isOn ? .black : .white
        self.present(viewController, animated: true, completion: nil)
    }
}

// MARK: TransitionDelegate
extension ImageViewController: TransitionDelegate {
    var transitionSuperview: UIView {
        return self.view
    }
    
    func transitionPresentFromView(_ base: BaseTransition) -> UIView? {
        return self.imageView
    }
    
    func transitionPresentFromImage(_ base: BaseTransition) -> UIImage? {
        return self.imageView.image
    }
    
    func transitionDismissToView(_ base: BaseTransition) -> UIView? {
        return self.imageView
    }
    
    func transitionWillPresent(_ base: BaseTransition, viewController: UIViewController) {
        print("transitionWillPresent")
    }
    
    func transitionDidPresent(_ base: BaseTransition, viewController: UIViewController) {
        print("transitionDidPresent")
    }
    
    func transitionWillDismiss(_ base: BaseTransition, viewController: UIViewController) {
        print("transitionWillDismiss")
    }
    
    func transitionDidDismiss(_ base: BaseTransition, viewController: UIViewController) {
        print("transitionDidDismiss")
    }
    
    func transitionGesture(_ base: BaseTransition, viewController: UIViewController, gesture: UIPanGestureRecognizer, progress: CGFloat) {
        switch gesture.state {
        case .began:
            base.transitionView.backgroundColor = self.colorSwitch.isOn ? .black : .white
        case .changed:
            base.transitionView.backgroundColor = self.colorSwitch.isOn ? UIColor.black.withAlphaComponent(progress / 3) : UIColor.white.withAlphaComponent(progress / 3)
        default:
            break
        }
    }
}
