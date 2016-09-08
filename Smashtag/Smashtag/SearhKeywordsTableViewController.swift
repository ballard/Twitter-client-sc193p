//
//  SearhKeywordsTableViewController.swift
//  Smashtag
//
//  Created by Ivan on 12.08.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit

class SearhKeywordsTableViewController: UITableViewController {
    
    private struct Keys{
        static let History = "Smashtag.History"
    }
    
    private struct Storyboard{
        static let KeywordCell = "Search Keyword"
        static let HistorySearchSegue = "History Search Segue"
        static let PopularityTableSegue = "Show Mention Popularity"
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    private var history : [String]?{
        get{
            return defaults.objectForKey(Keys.History) as? [String] ?? nil
        }
        set{
            defaults.setObject(newValue, forKey: Keys.History)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        print("reload data")
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Keywords"
//    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let searches = history{
            print("\(searches.count)")
            return searches.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.KeywordCell, forIndexPath: indexPath)
        
        if let keywords = history{
            let keyword = keywords[keywords.count - indexPath.row - 1]
            if let keywordCell = cell as? SearchKeywordTableViewCell{
                keywordCell.keywordValue = keyword
            }
        }

        // Configure the cell...

        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.HistorySearchSegue:
                if let cell = sender as? SearchKeywordTableViewCell,
                    let seguedToMVC = segue.destinationViewController as? TweetTableViewController {
                    seguedToMVC.searchText = cell.keywordValue
                }
            case Storyboard.PopularityTableSegue:
                if let cell = sender as? SearchKeywordTableViewCell,
                    let seguedToMVC = segue.destinationViewController as? TweetMentionPopularityTableViewController {
                    seguedToMVC.searchTerm = cell.keywordValue
                }
            default:
                break
            }
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            if let keywords = history{
                var editebleKeywords = keywords
                editebleKeywords.removeAtIndex(editebleKeywords.count - indexPath.row - 1)
                history = editebleKeywords
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

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
