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
    
    var imageURL : NSURL?{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var mentionImage: UIImageView!
    
    private func updateUI(){
        mentionImage?.image = nil
        if imageURL != nil{
            if let imageData = NSData(contentsOfURL: imageURL!){
                mentionImage?.image = UIImage(data: imageData)                
                mentionImage?.sizeToFit()
            }
        }
    }    
    
    // Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
