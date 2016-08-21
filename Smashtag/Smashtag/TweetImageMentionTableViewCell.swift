//
//  TweetImageMentionTableViewCell.swift
//  Smashtag
//
//  Created by Ivan on 01.08.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit

class TweetImageMentionTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var mentionImage: UIImageView!
    
    var reportImageLoaded : (() -> Void)?
    
    var imageURL : NSURL? {
        didSet{
            updateUI()
        }
    }
    
    var img : UIImage? {
        set{
            mentionImage?.image = newValue
            mentionImage?.sizeToFit()
            spinner.stopAnimating()
            if let report = reportImageLoaded{
                report()
            }
        }
        get{
            return mentionImage?.image
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func updateUI(){
        mentionImage?.image = nil
        if let url = imageURL {
            spinner.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                [weak weakSelf = self] in
                let contentOfUrl = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()){
                    if url == weakSelf?.imageURL{
                        if let imageData = contentOfUrl {
                            weakSelf?.img = UIImage(data: imageData)
                        } else {
                            weakSelf?.spinner?.stopAnimating()
                        }
                    } else {
                        print("url dropped")
                    }
                }
            }
        }
    }
    
}
