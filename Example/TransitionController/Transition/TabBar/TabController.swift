//
//  TabController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import TransitionController

class TabController: UIViewController {
    @IBOutlet private weak var tabButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 236/255, green: 232/255, blue: 219/255, alpha: 1)
        self.tabButton.layer.cornerRadius = self.tabButton.frame.width/2
        self.tabButton.backgroundColor = UIColor(red: 72/255, green: 91/255, blue: 102/255, alpha: 1)
        self.tabButton.setTitleColor(UIColor(red: 215/255, green: 202/255, blue: 182/255, alpha: 1), for: .normal)
        self.tabButton.clipsToBounds = true
    }
    
    @IBAction private func tab(_ sender: UIButton) {
        let tabBarController = CustomTabBarController()
        tabBarController.transitionDelegate = self
        self.present(tabBarController, animated: true, completion: nil)
    }
}

// MARK: TransitionDelegate
extension TabController: TransitionDelegate {
    var transitionSuperview: UIView {
        return self.view
    }
    
    func transitionPresentFromView(_ base: BaseTransition) -> UIView? {
        return self.tabButton
    }
    
    func transitionDismissToView(_ base: BaseTransition) -> UIView? {
        return self.tabButton
    }
}
