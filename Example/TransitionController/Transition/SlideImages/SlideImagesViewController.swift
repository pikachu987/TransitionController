//
//  SlideImagesViewController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import TransitionController

class SlideImagesViewController: UIViewController {
    private lazy var array: [UIImage?] = {
        var array = [UIImage?]()
        for index in 1...9 {
            array.append(UIImage(named: "image\(index).jpg"))
        }
        array.append(contentsOf: array)
        array.append(contentsOf: array)
        array.append(contentsOf: array)
        return array
    }()
    
    private let collectonView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectonView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectonView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        return collectonView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        self.view.addSubview(self.collectonView)
        self.collectonView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self.collectonView])
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self.collectonView])
        )
        DispatchQueue.main.async {
            self.collectonView.delegate = self
            self.collectonView.dataSource = self
        }
    }
}

// MARK: UICollectionViewDelegate
extension SlideImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = HorizontalSlideViewController()
        viewController.delegate = self
        let navigationController = HorizontalSlideNavigationController(rootViewController: viewController)
        navigationController.transitionDelegate = self
        navigationController.key = indexPath.item
        navigationController.navigationBarColor = .clear
        navigationController.view.backgroundColor = .black
        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource
extension SlideImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else { fatalError() }
        cell.image = self.array[indexPath.item]
        return cell
    }
}

// MARK: HorizontalSlideDelegate
extension SlideImagesViewController: HorizontalSlideDelegate {
    var horizontalSlideImages: [UIImage?] {
        return self.array
    }
    
    func horizontalSlide(_ index: Int) {
        self.collectonView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)
    }
}

// MARK: TransitionDelegate
extension SlideImagesViewController: TransitionDelegate {
    var transitionSuperview: UIView {
        return self.view
    }
    
    func transitionPresentFromView(_ base: BaseTransition) -> UIView? {
        guard let index = base.key as? Int else { return nil }
        return self.collectonView.cellForItem(at: IndexPath(item: index, section: 0))
    }
    
    func transitionPresentFromImage(_ base: BaseTransition) -> UIImage? {
        guard let index = base.key as? Int else { return nil }
        return self.array[index]
    }
    
    func transitionDismissToView(_ base: BaseTransition) -> UIView? {
        guard let index = base.key as? Int else { return nil }
        return self.collectonView.cellForItem(at: IndexPath(item: index, section: 0))
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
    
}
