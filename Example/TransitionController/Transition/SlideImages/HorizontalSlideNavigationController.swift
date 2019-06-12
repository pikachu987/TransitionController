//
//  HorizontalSlideNavigationController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import TransitionController

class HorizontalSlideNavigationController: TransitionNavigationController {
    override var dismissFromView: UIView? {
        guard let viewController = self.visibleViewController as? HorizontalSlideViewController else { return nil }
        return viewController.visibleCell
    }
    
    override var dismissFromImage: UIImage? {
        guard let viewController = self.visibleViewController as? HorizontalSlideViewController else { return nil }
        return viewController.visibleImage
    }
    
    override func transitionRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _  = gestureRecognizer as? UIScreenEdgePanGestureRecognizer {
            return true
        } else if let _  = gestureRecognizer as? UIPanGestureRecognizer {
            return (self.visibleViewController as? HorizontalSlideViewController) != nil
        }
        return false
    }
}
