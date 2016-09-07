//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Ivan Lazarev on 20.07.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit
import Twitter

extension NSMutableAttributedString{
    func setMentionColor(mentions: [Twitter.Mention], color: UIColor) {
        for mention in mentions{
            addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var TweetProfileImageView: UIImageView!
    
    var tweet : Twitter.Tweet? {
        didSet{
            updateUI()
        }
    }
    
//    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var imageURL: NSURL?
    
    private func updateUI(){
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        TweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet{
                        
            let currentAttributedText = NSMutableAttributedString(string: tweet.text)
            currentAttributedText.setMentionColor(tweet.urls, color: UIColor.redColor())
            currentAttributedText.setMentionColor(tweet.hashtags, color: UIColor.greenColor())
            currentAttributedText.setMentionColor(tweet.userMentions, color: UIColor.blueColor())
            tweetTextLabel?.attributedText = currentAttributedText
            
            if tweetTextLabel.text != nil{
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
//                spinner?.startAnimating()
                imageURL = profileImageURL
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                    [weak weakSelf = self] in
                    let contentOfUrl = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()){
                        if profileImageURL == weakSelf?.imageURL {
                            if let imageData = contentOfUrl {
                                weakSelf?.TweetProfileImageView?.image = UIImage(data: imageData)
//                                weakSelf?.spinner?.stopAnimating()
                            } //else {
//                                weakSelf?.spinner?.stopAnimating()
                            //}
                        } else {
                            print("url dropped")
                        }
                    }
                }
                
//                if let imageData = NSData(contentsOfURL: profileImageURL){
//                    TweetProfileImageView?.image = UIImage(data: imageData)
//                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60{
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }    
}
