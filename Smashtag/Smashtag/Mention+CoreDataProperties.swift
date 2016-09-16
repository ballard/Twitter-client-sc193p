//
//  Mention+CoreDataProperties.swift
//  Smashtag
//
//  Created by Ivan on 14.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Mention {

    @NSManaged var rate: NSNumber?
    @NSManaged var type: String?
    @NSManaged var value: String?
    @NSManaged var term: SearchTerm?
    @NSManaged var tweets: NSSet?    
    
    @NSManaged func addTweetsObject(tweet: Tweet)
    @NSManaged func addTweets(tweets: NSSet)
    
    class func fillMentionsDictWithMentionPayload(payload: [MentionPayload]) -> [String : [String]] {
        var mentionsDict : [String : [String]] = [:]
        for mention in payload {
            if let oldCount = mentionsDict[mention.value] {
                mentionsDict[mention.value] = oldCount + [mention.tweetId]
            } else {
                mentionsDict[mention.value] = [mention.tweetId]
            }
        }
        return mentionsDict
    }

}
