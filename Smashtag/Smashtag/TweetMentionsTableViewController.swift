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
    var tweet : Tweet?
    
    // Constants
    struct Storyboard {
        static let TextCellIdentifier = "text"
        static let ImageCellIdentifier = "image"
        static let AnotherSearchTableSegue = "Show table"
    }
    
    // Lifecycle

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    // MARK: - Table view data source
    
    // MARK: - Table view data source: UITableViewDataSource
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return makeCellForIndexPath(NSIndexPath(forItem: 0, inSection: section), isDescrtiption: true).2
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return makeCellForIndexPath(NSIndexPath(forItem: 0, inSection: section), isDescrtiption: true).1
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
        return UITableViewAutomaticDimension
    }
    
    private var operations = [
        0 : Operation.ImageCell,
        1 : Operation.TextCell(.hashtags),
        2 : Operation.TextCell(.userMentions),
        3 : Operation.TextCell(.urls)
    ]
    
    private enum Operation {
        case TextCell(MentionTypes)
        case ImageCell
    }
    
    private enum MentionTypes: String {
        case hashtags
        case userMentions
        case urls
    }
    
    private func getMention (type: MentionTypes) -> [Mention]? {
        switch type {
        case .hashtags: return tweet!.hashtags
        case .userMentions: return tweet!.userMentions
        case .urls: return tweet!.urls
        }
    }
    
    private func getImageCell(url: NSURL, forIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath)
        if let imageCell = cell as? TweetImageMentionTableViewCell{
            imageCell.imageURL = url
        }
        return cell
    }
    
    private func getTextCell(content: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellIdentifier, forIndexPath: indexPath)
        if let tweetCell = cell as? TweetTextMentionTableViewCell{
            tweetCell.mentionContent = content
        }
        return cell
    }
    
    private func makeCellForIndexPath(indexPath: NSIndexPath, isDescrtiption description: Bool) -> (UITableViewCell, Int, String){
        if let operation = operations[indexPath.section]{
            switch operation {
            case .ImageCell:
                if !description{
                    if let imageMentionURL = tweet?.media[indexPath.row].url { return (getImageCell(imageMentionURL, forIndexPath: indexPath), 0, "" )}
                } else { return (UITableViewCell(), tweet!.media.count, "media") }
            case .TextCell(let mentionType):
                if !description{
                if let textMention = getMention(mentionType)?[indexPath.row].keyword { return (getTextCell(textMention, forIndexPath: indexPath), 0, "") }
                } else { return (UITableViewCell(), getMention(mentionType)!.count, mentionType.rawValue) }
            }
        }
        return (UITableViewCell(), Int.min, "")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            return makeCellForIndexPath(indexPath, isDescrtiption: false).0
    }
    
    private var notURLCell = true
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 3 {
            notURLCell = false
            if let urlCell = tableView.cellForRowAtIndexPath(indexPath) as? TweetTextMentionTableViewCell{
                UIApplication.sharedApplication().openURL(NSURL(string: urlCell.mentionContent)!)
            }
        } else {
            notURLCell = true
        }
        return indexPath
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return notURLCell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier where identifier == Storyboard.AnotherSearchTableSegue{
            if let cell = sender as? TweetTextMentionTableViewCell,
                let seguedToMVC = segue.destinationViewController as? TweetTableViewController{
                seguedToMVC.searchText = cell.mentionContent
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
