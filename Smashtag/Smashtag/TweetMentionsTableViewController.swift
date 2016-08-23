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
    
    struct SectionTitles {
        static let Hashtags = "Hashtags"
        static let URLs = "URLs"
        static let Users = "Users"
        static let Images = "Images"
    }
    
    // Model    
    var tweet : Tweet?{
        didSet{
            if let mediaMentionItems = tweet?.media.map({ MensionItem.Image($0.url, $0.aspectRatio) }) {
                sections.append(Section(type: SectionTitles.Images, mensions: mediaMentionItems))
            }
            if let hashtags = tweet?.hashtags { appendTextMension(hashtags, forMensionType: SectionTitles.Hashtags) }
            if let urls = tweet?.urls { appendTextMension(urls, forMensionType: SectionTitles.URLs) }
            if let userMensions = tweet?.userMentions { appendTextMension(userMensions, forMensionType: SectionTitles.Users) }
        }
    }
    
    private func appendTextMension(mension: [Mention], forMensionType type: String){
        var mensionItem = mension.map({ MensionItem.Keyword($0.keyword) })
        if type == SectionTitles.Users{
            if let currentTweet = tweet{
                mensionItem.insert(MensionItem.Keyword("@" + currentTweet.user.screenName), atIndex: mensionItem.startIndex)
            }
        }
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
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].mensions.count
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
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch sections[indexPath.section].mensions[indexPath.row] {
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath)
            if let imageCell = cell as? TweetImageMentionTableViewCell {
                imageCell.imageURL = url
                imageCell.reportImageLoaded = ({ [weak weakSelf = self] in
                    weakSelf?.imageLoaded = true
                    print("reported")
                    })
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
    
    private var imageLoaded = false
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if sections[indexPath.section].type == SectionTitles.URLs{
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
        if identifier == Storyboard.ShowImageSegue{
            return imageLoaded
        }
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
                    
                    var searchText = cell.mentionContent
                    
                    if searchText.characters.first! == "@"{
                        let fromUser = String(searchText.characters.dropFirst())
                        searchText = searchText + " OR from:" + fromUser
                        print("user search")
                    }
                    
                    seguedToMVC.searchText = searchText
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

    @IBAction func cancel(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
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
