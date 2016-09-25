//
//  Mention+CoreDataProperties.swift
//  Smashtag
//
//  Created by Ivan on 23.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData

extension Mention {


    @NSManaged var rate: NSNumber?
    @NSManaged var type: String?
    @NSManaged var value: String?
    @NSManaged var term: SearchTerm?
    @NSManaged var tweet: NSSet?

}

// MARK: Generated accessors for tweet
extension Mention {

    @objc(addTweetObject:)
    @NSManaged func addToTweet(value: Tweet)

    @objc(removeTweetObject:)
    @NSManaged func removeFromTweet(value: Tweet)

    @objc(addTweet:)
    @NSManaged func addToTweet(values: NSSet)

    @objc(removeTweet:)
    @NSManaged func removeFromTweet(values: NSSet)

}
