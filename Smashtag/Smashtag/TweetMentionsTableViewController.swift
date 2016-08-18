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

            if let mediaMentionItems = tweet?.media.map({ MensionItem.Image($0.url, $0.aspectRatio) }) {
                sections.append(Section(type: "media", mensions: mediaMentionItems))
            }
            
            if let hashtags = tweet?.hashtags { appendTextMension(hashtags, forMensionType: "hashtags") }
            if let urls = tweet?.urls { appendTextMension(urls, forMensionType: "urls") }
            if let userMensions = tweet?.userMentions { appendTextMension(userMensions, forMensionType: "user mentions") }
            
//            if let hashtagsMensionItems = tweet?.hashtags.map({
//                MensionItem.Keyword($0.keyword)
//            }){
//                sections.append(Section(type: "hashtags", mensions: hashtagsMensionItems))
//            }
//            
//            if let urlsMensionItems = tweet?.urls.map({
//                MensionItem.Keyword($0.keyword)
//            }){
//                sections.append(Section(type: "urls", mensions: urlsMensionItems))
//            }
//            
//            if let userMensionItems = tweet?.userMentions.map({
//                MensionItem.Keyword($0.keyword)
//            }){
//                sections.append(Section(type: "user mentions", mensions: userMensionItems))
//            }
        }
    }
    
    private func appendTextMension(mension: [Mention], forMensionType type: String){
        let mensionItem = mension.map({ MensionItem.Keyword($0.keyword) })
        sections.append(Section(type: type, mensions: mensionItem))
    }
    
    // new model
    var sections = [Section]()
    
    struct Section {
        var type: String
        var mensions: [MensionItem]
    }
    
    enum MensionItem {
        case Keyword(String)
        case Image(NSURL, Double)
    }
    
    // old model
//    private var operations = [
//        0 : Operation.ImageCell,
//        1 : Operation.TextCell(.hashtags),
//        2 : Operation.TextCell(.userMentions),
//        3 : Operation.TextCell(.urls)
//    ]
//    
//    private enum Operation {
//        case TextCell(TextMentionType)
//        case ImageCell
//    }
//    
//    private enum TextMentionType: String {
//        case hashtags
//        case userMentions
//        case urls
//    }
//    
//    private func getMention (type: TextMentionType) -> [Mention]? {
//        switch type {
//        case .hashtags: return tweet!.hashtags
//        case .userMentions: return tweet!.userMentions
//        case .urls: return tweet!.urls
//        }
//    }
//    
//    private func getImageCell(url: NSURL, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath)
//        if let imageCell = cell as? TweetImageMentionTableViewCell {
//            imageCell.imageURL = url
//        }
//        return cell
//    }
//    
//    private func getTextCell(content: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellIdentifier, forIndexPath: indexPath)
//        if let tweetCell = cell as? TweetTextMentionTableViewCell{
//            tweetCell.mentionContent = content
//        }
//        return cell
//    }
//    
//    private func makeCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
//        if let operation = operations[indexPath.section] {
//            switch operation {
//            case .ImageCell: if let imageMentionURL = tweet?.media[indexPath.row].url { return getImageCell(imageMentionURL, forIndexPath: indexPath) }
//            case .TextCell(let mentionType):
//                if let textMention = getMention(mentionType)?[indexPath.row].keyword { return getTextCell(textMention, forIndexPath: indexPath) }
//            }
//        }
//        return UITableViewCell()
//    }
//    
//    private func getSectionDescription(section: Int) -> (Int, String) {
//        if let operation = operations[section]{
//            switch operation {
//            case .ImageCell: return (tweet!.media.count, "media")
//            case .TextCell(let mentionType): return (getMention(mentionType)!.count, mentionType.rawValue) }
//        } else { return (Int.min, "")}
//    }
    
    // Constants
    struct Storyboard {
        static let TextCellIdentifier = "text"
        static let ImageCellIdentifier = "image"
        static let AnotherSearchTableSegue = "Show table"
        static let ShowImageSegue = "Show Image"
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
        return sections[section].type
//        return getSectionDescription(section).1
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
        
//        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].mensions.count

//        return getSectionDescription(section).0
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if tableView.numberOfRowsInSection(section) == 0 {
            view.hidden = true
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch sections[indexPath.section].mensions[indexPath.row] {
        case .Image(_, let ratio): return tableView.frame.width / CGFloat(ratio)
        default: return UITableViewAutomaticDimension
        }
        
//        if indexPath.section == 0 {
//            if let ratio = tweet?.media[indexPath.row].aspectRatio {
//                return self.tableView.frame.width / CGFloat(ratio)
//            }
//        }
//        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch sections[indexPath.section].mensions[indexPath.row] {
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath)
            if let imageCell = cell as? TweetImageMentionTableViewCell {
                imageCell.imageURL = url
            }
            return cell
        case .Keyword(let mension):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellIdentifier, forIndexPath: indexPath)
            if let tweetCell = cell as? TweetTextMentionTableViewCell{
                tweetCell.mentionContent = mension
            }
            return cell
        }
    }
    
    private var notURLCell = true
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 3 {
            notURLCell = false
            if let urlCell = tableView.cellForRowAtIndexPath(indexPath) as? TweetTextMentionTableViewCell {
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
        
        if let identifier = segue.identifier{
            switch identifier {
            case Storyboard.AnotherSearchTableSegue:
                if let cell = sender as? TweetTextMentionTableViewCell,
                    let seguedToMVC = segue.destinationViewController as? TweetTableViewController {
                    seguedToMVC.searchText = cell.mentionContent
                }
            case Storyboard.ShowImageSegue:
                if let cell = sender as? TweetImageMentionTableViewCell,
                    let seguedToMVC = segue.destinationViewController as? MediaViewController{
                    seguedToMVC.image = cell.mentionImage.image
                }
            default:
                break
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
