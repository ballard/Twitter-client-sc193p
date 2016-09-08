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

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Model
    var managedDocument : UIManagedDocument? //{
//        let coreDataFileManager = NSFileManager.defaultManager()
//        if let coreDataFileDir = coreDataFileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
//            let url = coreDataFileDir.URLByAppendingPathComponent("TwitterDocument")
//            let document = UIManagedDocument(fileURL: url)
//            
//            if document.documentState == .Normal {
//                print("document normal")
//                return document
//            }
//            
//            if document.documentState == .Closed {
//                if let path = url.path {
//                    let fileExists = NSFileManager.defaultManager().fileExistsAtPath(path)
//                    if fileExists {
//                        print("opening document")
//                        document.openWithCompletionHandler({ (success) in
//                            return document
//                        })
//                    } else {
//                        print("creating document")
//                        document.saveToURL(url, forSaveOperation: .ForCreating, completionHandler: { (success) in
//                            return document
//                        })
//                    }
//                }
//            }
//        }
//        print("document fail")
//        return nil
//    }
    
    var tweets = [Array<Twitter.Tweet>](){
        didSet{
            tableView.reloadData()
            
//            print("tweets: \(tweets)")
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
        
        if tempHistory.count > 99 {
            tempHistory.removeFirst()
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
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func updateDatabase(newTweets: [Twitter.Tweet]){
        managedDocument?.managedObjectContext.performBlock {
            print("block performed")
            for twitterInfo in newTweets{
                _ = Tweet.tweetWithTweeterInfo(twitterInfo, forSearchTerm: self.searchText!, inManagedObjectContext: (self.managedDocument?.managedObjectContext)!)
            }
        }
        printDatabaseStatistics()
        print("done print database statistics")
    }
    
    
    private func printDatabaseStatistics(){
        managedDocument?.managedObjectContext.performBlock{
            let tweetCount = self.managedDocument?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Tweet"), error: nil)
            print("\(tweetCount!) Tweets")
            let mentionsCount = self.managedDocument?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Mention"), error: nil)
            print("\(mentionsCount!) Mentions")
            let searchTermsCont = self.managedDocument?.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "SearchTerm"), error: nil)
            print("\(searchTermsCont!) SearchTerms")
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
                        document.openWithCompletionHandler({ (success) in
                            return self.managedDocument = document
                        })
                    } else {
                        print("creating document")
                        document.saveToURL(url, forSaveOperation: .ForCreating, completionHandler: { (success) in
                            return self.managedDocument = document
                        })
                    }
                }
            }
        }
        
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
