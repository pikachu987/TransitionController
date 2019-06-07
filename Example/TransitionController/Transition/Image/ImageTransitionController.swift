//
//  ImageTransitionController.swift
//  TransitionController
//
//  Created by pikachu987 on 06/05/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import TransitionController

class ImageTransitionController: TransitionViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override var presentToView: UIView? {
        let view = UIView(frame: self.imageView.frameForImageInImageViewAspectFit)
        view.contentMode = .scaleAspectFit
        return view
    }

    override var dismissFromView: UIView? {
        return self.imageView
    }
    
    override var dismissFromImage: UIImage? {
        return self.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = image
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFit
        
        self.scrollView.backgroundColor = .clear
        self.scrollView.zoomScale = 1
        self.scrollView.minimumZoomScale = 0.1
        self.scrollView.maximumZoomScale = 3
        self.scrollView.clipsToBounds = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
    }
}

// MARK: UIScrollViewDelegate
extension ImageTransitionController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= 1 {
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        } else {
            let imageSize = self.imageView.frameForImageInImageViewAspectFit
            
            let widthRate =  self.view.bounds.width / imageSize.width
            let heightRate = self.view.bounds.height / imageSize.height
            
            if widthRate < heightRate {
                let imageOffset = -imageSize.origin.y
                let scrollOffset = (scrollView.bounds.height - scrollView.contentSize.height) * 0.5
                if imageOffset > scrollOffset {
                    scrollView.contentInset = UIEdgeInsets(top: imageOffset, left: 0, bottom: imageOffset, right: 0)
                } else {
                    scrollView.contentInset = UIEdgeInsets(top: scrollOffset, left: 0, bottom: scrollOffset, right: 0)
                }
            } else {
                let imageOffset = -imageSize.origin.x
                let scrollOffset = (scrollView.bounds.width - scrollView.contentSize.width) * 0.5
                if imageOffset > scrollOffset {
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: imageOffset)
                } else {
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: scrollOffset, bottom: 0, right: scrollOffset)
                }
            }
        }
    }
}
