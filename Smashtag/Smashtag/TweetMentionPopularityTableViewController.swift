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
    
    override func viewDidAppear(animated: Bool) {
        title = searchTerm
        printDatabaseStatistics()
        updateUI()
    }
    
    private func updateUI() {
        if let context = ManagedDocument.sharedInstance.document?.managedObjectContext where searchTerm?.characters.count > 0 {
            print("search term for table: \(searchTerm!.lowercaseString)")
            let request = NSFetchRequest(entityName: "Mention")
            request.predicate = NSPredicate(format: "term.value = %@ and rate > 1", searchTerm!.lowercaseString)
            
            
//            request.predicate = NSPredicate(format: "SUBQUERY(tweets, $tweet, any $tweet.searchTerms.value = %@).@count > 1", searchTerm!.lowercaseString)
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "type",
                    ascending: false,
                    selector: nil),
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
                sectionNameKeyPath: "type",
                cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
    private func printDatabaseStatistics() {
        ManagedDocument.sharedInstance.document?.managedObjectContext.performBlock{
//            let tweetCount = ManagedDocument.sharedInstance.document?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Tweet"), error: nil)
//            print("\(tweetCount!) Tweets")
            let mentionsCount = ManagedDocument.sharedInstance.document?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Mention"), error: nil)
            print("\(mentionsCount!) Mentions")
            
//            if let results = try? self.managedDocument?.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "Mention")) {
//                for result in results! {
//                    if let mention = result as? Mention{
//                        print("mention value: \(mention.value!)")
//                    }
//                }
//                print("\(results!.count) TwitterUsers")
//            }
            
            let searchTermsCont = ManagedDocument.sharedInstance.document?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "SearchTerm"), error: nil)
            print("\(searchTermsCont!) SearchTerms")
        }
    }    
    
//    private func mentionCountInTweets(mention: Mention) -> Int?{
//        var count: Int?
//        ManagedDocument.sharedInstance.document?.managedObjectContext.performBlockAndWait{
//            let request = NSFetchRequest(entityName: "Tweet")
//            request.predicate = NSPredicate(format: "text contains[c] %@ and any searchTerms.value = %@", mention.value!, self.searchTerm!.lowercaseString)
//            count = ManagedDocument.sharedInstance.document?.managedObjectContext.countForFetchRequest(request, error: nil)
//        }
//        
//        return count
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Mention Rating", forIndexPath: indexPath)
        
        // Configure the cell...
        if let mention = fetchedResultsController?.objectAtIndexPath(indexPath) as? Mention {
//            print("mention: \(mention)")
            var mentionValue : String?
            var mentionRate : Int?
            mention.managedObjectContext?.performBlockAndWait {
                mentionValue = mention.value!
                mentionRate = Int(mention.rate!)
            }
            cell.textLabel?.text = mentionValue
            cell.detailTextLabel?.text = "\(mentionRate!)"
            
            
//            if let count = mentionCountInTweets(mention) {
//                cell.detailTextLabel?.text = (count == 1) ? "Mentioned 1 time" : ("Mentioned \(count) times")
//            } else {
//                cell.detailTextLabel?.text = ""
//            }
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
