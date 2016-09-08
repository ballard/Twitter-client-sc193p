//
//  Tweet.swift
//  Smashtag
//
//  Created by Ivan on 07.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData
import Twitter


class Tweet: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func tweetWithTweeterInfo(twitterInfo: Twitter.Tweet, forSearchTerm termInfo: String, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? Tweet {
            return tweet
        } else {
            if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as? Tweet{
                tweet.unique = twitterInfo.id
                tweet.text = twitterInfo.text
                tweet.created = twitterInfo.created
                
                let searchTerm = SearchTerm.searchTermWithSearchTermInfo(termInfo.lowercaseString, inManagedObjectContext: context)
                tweet.addSearchTermsObject(searchTerm!)
                
                for hashtag in twitterInfo.hashtags {
                    let mention = Mention.mentionWithMentionInfo(hashtag.keyword.lowercaseString, withMentionType: "hashtag", inManagedObjectContext: context)
                    tweet.addMentionsObject(mention!)
                }
                
                for userMention in twitterInfo.userMentions {
                    let mention = Mention.mentionWithMentionInfo(userMention.keyword.lowercaseString, withMentionType: "userMention", inManagedObjectContext: context)
                    tweet.addMentionsObject(mention!)
                }
                
                return tweet
            }
        }
        
        return nil
    }

}
