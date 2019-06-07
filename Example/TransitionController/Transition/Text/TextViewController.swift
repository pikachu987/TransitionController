//
//  TextViewController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import TransitionController

class TextViewController: UIViewController {
    @IBOutlet private weak var textButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 236/255, green: 232/255, blue: 219/255, alpha: 1)
    }
    
    @IBAction private func textTap(_ sender: UIButton) {
        guard let viewController = UIStoryboard(name: "Text", bundle: nil).instantiateViewController(withIdentifier: "TextDetailViewController") as? TextDetailViewController else { return }
        guard let textURL = Bundle.main.url(forResource: "text", withExtension: "txt") else { return }
        viewController.text = try? String(contentsOf: textURL)
        let navigationController = TextNavigationController(rootViewController: viewController)
        navigationController.transitionDelegate = self
        navigationController.view.backgroundColor = .white
        navigationController.key = sender
        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: TransitionDelegate
extension TextViewController: TransitionDelegate {
    var transitionSuperview: UIView {
        return self.view
    }
    
    func transitionPresentFromView(_ base: BaseTransition) -> UIView? {
        return self.textButton
    }
    
    func transitionDismissToView(_ base: BaseTransition) -> UIView? {
        return self.textButton
    }
}
