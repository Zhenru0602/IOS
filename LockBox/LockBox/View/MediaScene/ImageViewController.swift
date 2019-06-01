//
//  ImageViewController.swift
//  LockBox
//
//  Created by Zhenru on 6/1/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: viewModel.currentContent)
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
    }
    
    
    
    func configure(with content: Content) {
        
        switch content.isVideo {
        case true:
            
            guard let url = FileService.loadWithFM(content.path!), let image = url.thumbnailForVideo() else {
                return
            }
            
            photoImageView.image = image
            
        case false:
            
            guard let url = FileService.loadWithFM(content.path!), let image = UIImage(contentsOfFile: url.path) else {
                return
            }
            
            photoImageView.image = image
        }
    }
    

}

extension ImageViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
}
