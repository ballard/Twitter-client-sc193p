//
//  SearchKeywordTableViewCell.swift
//  Smashtag
//
//  Created by Ivan on 12.08.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit

class SearchKeywordTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var keyword: UILabel!
    
    var keywordValue = "123"{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        keyword?.text = keywordValue
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
