//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Ivan Lazarev on 19.07.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit
import Twitter
import CoreData


struct MentionInfo {
    var value : String
    var type : String
}

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Model
    var tweets = [Array<Twitter.Tweet>](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var searchText: String?{
        didSet{
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            title = searchText
            navigationController?.title = "Tweets"
            updateHistory(searchText!)
        }
    }
    
    private struct Keys{
        static let History = "Smashtag.History"
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
    
    private func updateHistory(input: String){
        
        let lowInput = input.lowercaseString
        
        var tempHistory = [String]()
        if let storedHistory = history{
            tempHistory = storedHistory
        }
        
        if tempHistory.count > 0{
            for keyIndex in 0..<tempHistory.count {
                if tempHistory[keyIndex] == lowInput {
                    tempHistory.removeAtIndex(keyIndex)
                    break
                }
            }
        }
        
        if tempHistory.count > 4 {
            print("deleting old term")
            let deletingTerm = tempHistory.first!
            var request = NSFetchRequest(entityName: "SearchTerm")
            request.predicate = NSPredicate(format: "value = %@", deletingTerm)
            ManagedDocument.sharedInstance.document?.managedObjectContext.performBlockAndWait {
                do {
                    if let term = try ManagedDocument.sharedInstance.document!.managedObjectContext.executeFetchRequest(request).first! as? SearchTerm {
                        print("term to delete: \(term.value!)")
                        ManagedDocument.sharedInstance.document!.managedObjectContext.deleteObject(term)
                    }
                } catch let error {
                    print("error: \(error)")
                }
            }
            
            request = NSFetchRequest(entityName: "Tweet")
            request.predicate = NSPredicate(format: "mentions.@count == 0")
            ManagedDocument.sharedInstance.document?.managedObjectContext.performBlockAndWait {
                do {
                    if let tweetsToDelete = try ManagedDocument.sharedInstance.document!.managedObjectContext.executeFetchRequest(request) as? [Tweet] {
                        for tweetToDelete in tweetsToDelete {
                            ManagedDocument.sharedInstance.document!.managedObjectContext.deleteObject(tweetToDelete)
                        }
                    }
                } catch let error {
                    print("error: \(error)")
                }
            }
            
            printDatabaseStatistics()
            tempHistory.removeFirst()
            //place to clear database
            
        }
        tempHistory.append(lowInput)
        history = tempHistory
        print("\(history)")
    }
    
    
    // Fetching tweets
    private var twitterRequest: Twitter.Request?{
        if lastTwitterRequest == nil{
            if let query = searchText where !query.isEmpty {
                return Twitter.Request(search: query + " -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.requestForNewer
    }
    
    private var lastTwitterRequest : Twitter.Request?
    
    private func searchForTweets(){
        if let request = twitterRequest{
            lastTwitterRequest = request
            request.fetchTweets{ [ weak weakSelf = self ] newTweets in
                dispatch_async(dispatch_get_main_queue()) {
                    if request == weakSelf?.lastTwitterRequest{
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, atIndex: 0)
                            weakSelf?.showImagesBurron.enabled = true
                            weakSelf?.updateDatabase(newTweets)
                            print("searched text: \(weakSelf?.searchText!)")
                            print("new tweets count: \(newTweets.count)")
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }

    
    private func updateDatabase(newTweets: [Twitter.Tweet]) {
        ManagedDocument.sharedInstance.document?.managedObjectContext.performBlock {
            
//            let hashtags = newTweets.flatMap {
//                $0.hashtags.map {
//                    MentionInfo(value: $0.keyword, type: "Hashtag")
//                }
//            }
//            
//            let userMentons = newTweets.flatMap{
//                $0.userMentions.map {
//                    MentionInfo(value: $0.keyword, type: "User Mention")
//                }
//            }
            
//            print("new tweets: \(newTweets.count)")
            
            let hashtags = newTweets.flatMap { $0.hashtags.map { $0.keyword.lowercaseString } }
            let userMentions = newTweets.flatMap{ $0.userMentions.map { $0.keyword.lowercaseString } }
            let mentions = hashtags + userMentions
            
            var mentionsDict : [String : Int] = [:]
            
            for mention in mentions {
                if let oldCount = mentionsDict[mention] {
                    mentionsDict[mention] = oldCount + 1
                } else {
                    mentionsDict[mention] = 1
                }
            }
            
//            print("mentionsDict: \(mentionsDict)")
            
            Mention.mentionsWithTweetsInfo(newTweets, forSearchTermInfo: self.searchText!.lowercaseString, inManagedObjectContext: ManagedDocument.sharedInstance.document!.managedObjectContext)
            
            print("search term info: \(self.searchText!.lowercaseString)")
            
            for tweet in newTweets{
                for hashtag in tweet.hashtags {
                    _ = Mention.mentionWithMentionInfo(hashtag.keyword.lowercaseString, withMentionType: "Hashtags", forSearchTermInfo: self.searchText!.lowercaseString, forTweetInfo: tweet.id.lowercaseString, inManagedObjectContext: ManagedDocument.sharedInstance.document!.managedObjectContext)
                }
                
                for userMention in tweet.userMentions {
                    _ = Mention.mentionWithMentionInfo(userMention.keyword.lowercaseString, withMentionType: "User Mentions", forSearchTermInfo: self.searchText!.lowercaseString, forTweetInfo: tweet.id.lowercaseString, inManagedObjectContext: ManagedDocument.sharedInstance.document!.managedObjectContext)
                }
            }
        }
        printDatabaseStatistics()
        print("done print database statistics")
    }    
    
    private func printDatabaseStatistics(){
        ManagedDocument.sharedInstance.document?.managedObjectContext.performBlock{
            let mentionsCount = ManagedDocument.sharedInstance.document?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Mention"), error: nil)
            print("\(mentionsCount!) Mentions")
            let searchTermsCont = ManagedDocument.sharedInstance.document?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "SearchTerm"), error: nil)
            print("\(searchTermsCont!) SearchTerms")
            let tweetsCount = ManagedDocument.sharedInstance.document?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Tweet"), error: nil)
            print("\(tweetsCount!) tweetsCount")
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        searchForTweets()
    }
    
    // MARK: - Table view data source: UITableViewDataSource
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]        
        if let tweetCell = cell as? TweetTableViewCell{
            tweetCell.tweet = tweet
        }        

        // Configure the cell...

        return cell
    }
    
    //Constants
    private struct Storyboard{
        static let TweetCellIdentifier = "Tweet"
        static let ShowMentionSegueIdentifier = "Show Mention"
        static let ShowImages = "Show Images"
    }
    
    //Outlets
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    //Delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    //Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ManagedDocument.sharedInstance
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        guard searchText == nil && tweets.count == 0 else { return }
        
        if let lastSearch = history?.last {
            searchText = lastSearch
            searchTextField.text = lastSearch
        
        } else {
            title = "Tweets"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if let navcon = navigationController{
            if navcon.viewControllers.count == 1{
                backToRootOutlet.title = ""
                backToRootOutlet.enabled = false
            } else {
                backToRootOutlet.title = "🔙"
                backToRootOutlet.enabled = true
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier{
            switch identifier {
            case Storyboard.ShowMentionSegueIdentifier:
                if let cell = sender as? TweetTableViewCell,
                    let indexPath = tableView.indexPathForCell(cell),
                    let seguedToMVC = segue.destinationViewController as? TweetMentionsTableViewController{
                    seguedToMVC.tweet = tweets[indexPath.section][indexPath.row]
                }
            case Storyboard.ShowImages:
                if let seguedToMVC = segue.destinationViewController as? TweetImagesCollectionViewController {
                    seguedToMVC.tweets = tweets
                }
            default: break
            }
        }
    }
    
    @IBOutlet weak var backToRootOutlet: UIBarButtonItem!
    @IBOutlet weak var showImagesBurron: UIBarButtonItem!
    
    @IBAction func backToRoot(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
