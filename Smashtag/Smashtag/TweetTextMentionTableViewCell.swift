//
//  TweetTextMentionTableViewCell.swift
//  Smashtag
//
//  Created by Ivan on 01.08.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit

class TweetTextMentionTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var mentionText: UILabel!
    
    var mentionContent = "123"{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        mentionText?.text = mentionContent
    }
}
