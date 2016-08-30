//
//  TweetImagesCollectionViewController.swift
//  Smashtag
//
//  Created by Ivan on 25.08.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit
import Twitter

private let reuseIdentifier = "Cell"

struct imageData {
    var url : NSURL
    var aspectRatio: Double
    var tweet : Tweet
}

class TweetImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // Model
    var tweets = [Array<Twitter.Tweet>](){
        didSet{
            for section in tweets {
                for tweet in section {
                    for media in tweet.media {
                        imagesData.append(imageData(url: media.url, aspectRatio: media.aspectRatio, tweet: tweet))
                    }
                }
            }
            self.collectionView?.reloadData()
        }
    }
    
    var imagesData = [imageData]()
    
    struct Storyboard {
        static let ImageCell = "Image Cell"
        static let ShowTweet = "Show Tweet"
    }

    func zoom(recognizer : UIPinchGestureRecognizer) {
        if recognizer.state == .Changed {
            area *= recognizer.scale
            recognizer.scale = 1.0
            self.collectionView?.collectionViewLayout.invalidateLayout()//reloadData()
            print("zoom")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let zoomRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(TweetImagesCollectionViewController.zoom(_:)))
        self.collectionView!.addGestureRecognizer(zoomRecognizer)
        
        cache.countLimit = 100
        cache.totalCostLimit = 100000000
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier where identifier == Storyboard.ShowTweet {
                if let cell = sender as? TweetImageCollectionViewCell,
                    let indexPath = self.collectionView?.indexPathForCell(cell),
                    let seguedToMVC = segue.destinationViewController as? TweetTableViewController{
                    var tweetArray = [Tweet]()
                    tweetArray.append(imagesData[indexPath.row].tweet)
                    seguedToMVC.tweets.append(tweetArray)
                }
        }
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagesData.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.ImageCell, forIndexPath: indexPath)
        
        let tweet = imagesData[indexPath.row]
        if let tweetCell = cell as? TweetImageCollectionViewCell{
            tweetCell.tweet = tweet
            tweetCell.cache = cache
        }
    
        // Configure the cell
    
        return cell
    }
    
    let cache = NSCache()
    
    var area : CGFloat = 25000.0
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tweet = imagesData[indexPath.row]
        let size = CGSize( width: sqrt(area * CGFloat(tweet.aspectRatio)),
                           height: sqrt(area / CGFloat(tweet.aspectRatio)) )
        return size
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
