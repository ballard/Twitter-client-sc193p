//
//  MediaViewController.swift
//  Smashtag
//
//  Created by Ivan on 07.08.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController, UIScrollViewDelegate {
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    var image: UIImage?
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self
        }
    }
    
    private var wasInteracted = false
    
    func setZoomScale() {
        
        guard !wasInteracted else { return }
        
        let imageViewSize = imageView.bounds.size
        if let scrollViewSize = scrollView?.bounds.size{
            let widthScale = scrollViewSize.width / imageViewSize.width
            let heightScale = scrollViewSize.height / imageViewSize.height
            let scale = max(widthScale, heightScale)
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.zoomScale = scale
            scrollView.contentOffset = CGPoint(x: ( imageView.frame.size.width - scrollView.frame.size.width) / 2,
                                               y: ( imageView.frame.size.height - scrollView.frame.size.height ) / 2)
        }
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        wasInteracted = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        imageView.image = image
        imageView.sizeToFit()
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        setZoomScale()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({ (context) in
            self.setZoomScale()
            }, completion: nil )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
