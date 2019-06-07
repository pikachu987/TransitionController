//
//  TextNavigationController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import TransitionController

class TextNavigationController: TransitionNavigationController {
    override var presentToView: UIView? {
        guard let _ = self.visibleViewController as? TextDetailViewController else { return nil }
        let view = UIView()
        let top = UIApplication.shared.statusBarFrame.height + self.navigationBar.frame.height
        view.frame = CGRect(x: 0, y: top, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - top)
        view.backgroundColor = .white
        return view
    }
    
    override var isGesture: Bool {
        return (self.visibleViewController as? TextDetailViewController) != nil
    }
}
