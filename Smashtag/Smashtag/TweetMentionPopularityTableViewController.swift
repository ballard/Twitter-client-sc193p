//
//  TweetMentionPopularityTableViewController.swift
//  Smashtag
//
//  Created by Иван Лазарев on 07.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit
import CoreData

class TweetMentionPopularityTableViewController: CoreDataTableViewController {

    var searchTerm : String?
    
    var managedDocument : UIManagedDocument? {
        didSet {
//            printDatabaseStatistics()
            updateUI()
        }
    }
    
    private func updateUI() {
        if let context = managedDocument?.managedObjectContext where searchTerm?.characters.count > 0 {
            let request = NSFetchRequest(entityName: "Mention")
            request.predicate = NSPredicate(format: "SUBQUERY(tweets, $tweet, any $tweet.searchTerms.value contains[c] %@).@count > 1", searchTerm!)
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "rate",
                    ascending: false,
                    selector: nil),
                NSSortDescriptor(
                    key : "value",
                    ascending : true,
                    selector : #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
//    private func printDatabaseStatistics() {
//        managedDocument?.managedObjectContext.performBlock{
//            let tweetCount = self.managedDocument?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Tweet"), error: nil)
//            print("\(tweetCount!) Tweets")
//            let mentionsCount = self.managedDocument?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Mention"), error: nil)
//            print("\(mentionsCount!) Mentions")
//            
////            if let results = try? self.managedDocument?.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "Mention")) {
////                for result in results! {
////                    if let mention = result as? Mention{
////                        print("mention value: \(mention.value!)")
////                    }
////                }
////                print("\(results!.count) TwitterUsers")
////            }
//            
//            let searchTermsCont = self.managedDocument?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "SearchTerm"), error: nil)
//            print("\(searchTermsCont!) SearchTerms")
//        }
//    }
    
    override func viewDidAppear(animated: Bool) {
        let coreDataFileManager = NSFileManager.defaultManager()
        if let coreDataFileDir = coreDataFileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
            let url = coreDataFileDir.URLByAppendingPathComponent("TwitterDocument")
            let document = UIManagedDocument(fileURL: url)
            
            if document.documentState == .Normal {
                print("document normal")
                managedDocument = document
            }
            
            if document.documentState == .Closed {
                if let path = url.path {
                    let fileExists = NSFileManager.defaultManager().fileExistsAtPath(path)
                    if fileExists {
                        print("opening document")
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                            document.openWithCompletionHandler({ (success) in
                                dispatch_async(dispatch_get_main_queue()) {
                                    return self.managedDocument = document
                                }
                            })
                        }
                    } else {
                        print("creating document")
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                            document.saveToURL(url, forSaveOperation: .ForCreating, completionHandler: { (success) in
                                dispatch_async(dispatch_get_main_queue()) {
                                    return self.managedDocument = document
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    private func mentionCountInTweets(mention: Mention) -> Int?{
        var count: Int?
        managedDocument?.managedObjectContext.performBlockAndWait{
            let request = NSFetchRequest(entityName: "Tweet")
            request.predicate = NSPredicate(format: "text contains[c] %@ and any searchTerms.value == %@", mention.value!, self.searchTerm!)
            count = self.managedDocument?.managedObjectContext.countForFetchRequest(request, error: nil)
        }
        
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Mention Rating", forIndexPath: indexPath)
        
        // Configure the cell...
        if let mention = fetchedResultsController?.objectAtIndexPath(indexPath) as? Mention {
            var mentionValue : String?
            mention.managedObjectContext?.performBlockAndWait {
                mentionValue = mention.value!
            }
            cell.textLabel?.text = mentionValue
            
            if let count = mentionCountInTweets(mention) {
                cell.detailTextLabel?.text = (count == 1) ? "Mentioned 1 time" : ("Mentioned \(count) times")
            } else {
                cell.detailTextLabel?.text = ""
            }

        }
        // Configure the cell...

        return cell
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
