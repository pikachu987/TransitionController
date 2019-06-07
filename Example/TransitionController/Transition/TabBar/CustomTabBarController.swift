//
//  CustomTabBarController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import TransitionController

class CustomTabBarController: TransitionTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        var viewControllers = [UIViewController]()
        
        let viewControllerFirst = UIViewController()
        viewControllerFirst.view.backgroundColor = .white
        viewControllerFirst.tabBarItem = UITabBarItem(title: "First", image: nil, selectedImage: nil)
        viewControllers.append(viewControllerFirst)
        
        let viewControllerSecond = UIViewController()
        viewControllerSecond.view.backgroundColor = .white
        viewControllerSecond.tabBarItem = UITabBarItem(title: "Second", image: nil, selectedImage: nil)
        viewControllers.append(viewControllerSecond)
        
        let viewControllerThrid = UIViewController()
        viewControllerThrid.view.backgroundColor = .white
        viewControllerThrid.tabBarItem = UITabBarItem(title: "Third", image: nil, selectedImage: nil)
        viewControllers.append(viewControllerThrid)
        
        self.setViewControllers(viewControllers, animated: false)
    }
}
