//
//  ViewController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit

enum ControllerType: String {
    case image = "Image Example"
    case text = "Text Example"
    case slideImages = "Slide Images Example"
    case tabBar = "Tab Bar Example"
    
    static var array: [ControllerType] {
        return [.image, .text, .slideImages, .tabBar]
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = ControllerType.array[indexPath.row]
        switch type {
        case .image:
            let viewController = UIStoryboard(name: "Image", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        case .text:
            let viewController = UIStoryboard(name: "Text", bundle: nil).instantiateViewController(withIdentifier: "TextViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        case .slideImages:
            let viewController = UIStoryboard(name: "SlideImages", bundle: nil).instantiateViewController(withIdentifier: "SlideImagesViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        case .tabBar:
            let viewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabController")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ControllerType.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = ControllerType.array[indexPath.row].rawValue
        return cell
    }
}


