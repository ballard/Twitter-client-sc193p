//
//  Tweet.swift
//  Smashtag
//
//  Created by Ivan on 13.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class Tweet: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func tweetWithTweetInfo(tweetInfo: Twitter.Tweet, forSearchTerm term: String, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", tweetInfo)
        if let tweet = (try? context.executeFetchRequest(request))?.first as? Tweet {
            return tweet
        } else {
            if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as? Tweet {
                tweet.unique = tweetInfo.id
                tweet.created = tweetInfo.created
                
                for hashtag in tweetInfo.hashtags {
                    let mention = Mention.mentionWithMentionInfo(hashtag.keyword.lowercaseString, withMentionType: "hashtag", forSearchTermInfo: term.lowercaseString, inManagedObjectContext: context)
                    tweet.addToMentions(mention!)
                }
                
                for userMention in tweetInfo.userMentions {
                    let mention = Mention.mentionWithMentionInfo(userMention.keyword.lowercaseString, withMentionType: "userMention", forSearchTermInfo: term.lowercaseString, inManagedObjectContext: context)
                    tweet.addToMentions(mention!)
                }
                
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


