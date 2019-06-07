//
//  HorizontalSlideViewController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import TransitionController

protocol HorizontalSlideDelegate: class {
    var horizontalSlideImages: [UIImage?] { get }
    func horizontalSlide(_ index: Int)
}

class HorizontalSlideViewController: UIViewController {
    weak var delegate: HorizontalSlideDelegate?
    
    private let collectonView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectonView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectonView.isPagingEnabled = true
        collectonView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        return collectonView
    }()
    
    var visibleCell: UICollectionViewCell? {
        guard let currentIndexKey = (self.navigationController as? TransitionNavigationController)?.key as? Int else { return nil }
        return self.collectonView.cellForItem(at: IndexPath(item: currentIndexKey, section: 0))
    }
    
    var visibleImage: UIImage? {
        guard let currentIndexKey = (self.navigationController as? TransitionNavigationController)?.key as? Int else { return nil }
        return self.delegate?.horizontalSlideImages[currentIndexKey]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.collectonView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.backgroundColor = .black
        self.view.addSubview(self.collectonView)
        self.collectonView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self.collectonView])
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self.collectonView])
        )
        
        self.collectonView.delegate = self
        self.collectonView.dataSource = self
        
        if let index = (self.navigationController as? TransitionNavigationController)?.key as? Int {
            DispatchQueue.main.async {
                self.collectonView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
        
        let tempButton = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - 100, width: 120, height: 40))
        tempButton.setTitle("Temp Next", for: .normal)
        tempButton.layer.cornerRadius = 4
        tempButton.backgroundColor = .gray
        tempButton.addTarget(self, action: #selector(self.tempNextTap(_:)), for: .touchUpInside)
        self.view.addSubview(tempButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (self.navigationController as? TransitionNavigationController)?.navigationBarColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        (self.navigationController as? TransitionNavigationController)?.navigationBarColor = nil
    }
    
    @objc private func tempNextTap(_ sender: UIButton) {
        guard let textURL = Bundle.main.url(forResource: "text", withExtension: "txt") else { return }
        let tempViewController = UIViewController()
        tempViewController.view.backgroundColor = .white
        let textView = UITextView(frame: UIScreen.main.bounds)
        tempViewController.view.addSubview(textView)
        textView.text = try? String(contentsOf: textURL)
        self.navigationController?.pushViewController(tempViewController, animated: true)
    }
}

// MARK: UICollectionViewDelegate
extension HorizontalSlideViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let count = self.delegate?.horizontalSlideImages.count else { return }
        guard let currentIndexKey = (self.navigationController as? TransitionNavigationController)?.key as? Int else { return }
        let deltaOffset = scrollView.contentSize.width - scrollView.frame.size.width - scrollView.contentOffset.x
        let index =  CGFloat(count) - deltaOffset/scrollView.frame.size.width - 1
        let currentIndex = Int(round(index))
        if currentIndexKey != currentIndex && currentIndex >= 0 && currentIndex < count {
            (self.navigationController as? TransitionNavigationController)?.key = currentIndex
            self.delegate?.horizontalSlide(currentIndex)
        }
    }
}

// MARK: UICollectionViewDataSource
extension HorizontalSlideViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.horizontalSlideImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else { fatalError() }
        cell.image = self.delegate?.horizontalSlideImages[indexPath.item]
        return cell
    }
}
