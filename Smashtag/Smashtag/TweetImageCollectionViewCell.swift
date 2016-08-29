//
//  TweetImageCollectionViewCell.swift
//  Smashtag
//
//  Created by Ivan on 26.08.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit
import Twitter

class TweetImageCollectionViewCell: UICollectionViewCell {
    
    var tweet : imageData?{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL: NSURL?
    
    private func updateUI(){        
        imageView?.image = nil
        if let tweet = self.tweet{
            let profileImageURL = tweet.url
            imageURL = profileImageURL
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                [weak weakSelf = self] in
                let contentOfUrl = NSData(contentsOfURL: profileImageURL)
                dispatch_async(dispatch_get_main_queue()){
                    if profileImageURL == weakSelf?.imageURL {
                        if let imageData = contentOfUrl {
                            weakSelf?.imageView?.image = UIImage(data: imageData)
                        }
                    } else {
                        print("url dropped")
                    }
                }
            }
        }
    }
}
