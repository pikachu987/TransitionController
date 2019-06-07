//
//  TextDetailViewController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit

class TextDetailViewController: UIViewController {
    var text: String?
    
    @IBOutlet private weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.backTap(_:)))
        
        self.textView.isEditable = false
        self.textView.text = self.text
        
        DispatchQueue.main.async {
            self.textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        }
    }
    
    @objc private func backTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
