//
//  Tweet.swift
//  Smashtag
//
//  Created by Ivan on 13.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData


class Tweet: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func tweetWithTweetInfo(tweetInfo: String, forMention mention: Mention, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", tweetInfo)
        if let tweet = (try? context.executeFetchRequest(request))?.first as? Tweet {
            tweet.addMentionsObject(mention)
            return tweet
        } else {
            if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as? Tweet {
                tweet.unique = tweetInfo
                tweet.addMentionsObject(mention)
                return tweet
            }
        }
        return nil
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        print("deleteing object: \(self.unique!)")
    }
}


