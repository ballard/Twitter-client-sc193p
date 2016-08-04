//
//  TweetMentionsTableViewController.swift
//  Smashtag
//
//  Created by Ivan on 01.08.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit
import Twitter

class TweetMentionsTableViewController: UITableViewController {
    
    // Model
    
    var tweet : Tweet?{
        didSet{
            tableView.reloadData()
        }
    }
    
    // Constants
    struct Storyboard {
        static let TextCellIdentifier = "text"
        static let ImageCellIdentifier = "image"
        static let AnotherSearchTableSegue = "Show table"
    }
    
    // Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    // MARK: - Table view data source: UITableViewDataSource
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "images"
        case 1:
            return "hashtags"
        case 2:
            return "users"
        case 3:
            return "urls"
        default:
            return nil
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let currentTweet = tweet{
            switch section {
            case 0:
                return currentTweet.media.count
            case 1:
                return currentTweet.hashtags.count
            case 2:
                return currentTweet.userMentions.count
            case 3:
                return currentTweet.urls.count
            default:
                return 0
            }
        } else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if tableView.numberOfRowsInSection(section) == 0 {
            view.hidden = true
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let ratio = tweet?.media[indexPath.row].aspectRatio {
                return self.tableView.frame.width / CGFloat(ratio)
            }
        }
        return 35
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tweet != nil{
            func setMention(content: Mention) -> UITableViewCell{
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellIdentifier, forIndexPath: indexPath)
                if let tweetCell = cell as? TweetTextMentionTableViewCell{
                    tweetCell.mentionContent = content.keyword
                }
                return cell
            }
            // Configure the cell...
            switch indexPath.section {
            case 0:
                if let imageMentionURL = tweet?.media[indexPath.row].url{
                    let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath)
                    if let imageCell = cell as? TweetImageMentionTableViewCell{
                        imageCell.imageURL = imageMentionURL
                    }
                    return cell
                }
            case 1:
                setMention(tweet!.hashtags[indexPath.row])
            case 2:
                setMention(tweet!.userMentions[indexPath.row])
            case 3:
                setMention(tweet!.urls[indexPath.row])
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        switch indexPath.section {
//        case 1:
//            var mentionValue = ""
//            if let mentionString = tweet?.hashtags[indexPath.row].keyword {
//                mentionValue = mentionString
//            }
//            performSegueWithIdentifier(Storyboard.AnotherSearchTableSegue, sender: mentionValue)
//        default:
//            break
//        }
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier = segue.identifier where identifier == Storyboard.AnotherSearchTableSegue {
//            if let searchTweetMVC = segue.destinationViewController as? TweetTableViewController {
//                searchTweetMVC.searchText = sender as? String
//                searchTweetMVC.searchTextField.text = sender as? String
//            }
//        }
//    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier where identifier == Storyboard.AnotherSearchTableSegue{
            if let cell = sender as? TweetTableViewCell,
                let indexPath = tableView.indexPathForCell(cell),
                let seguedToMVC = segue.destinationViewController as? TweetTableViewController{
                seguedToMVC.searchText = "#doom2016"// tweet = tweets[indexPath.section][indexPath.row]
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
