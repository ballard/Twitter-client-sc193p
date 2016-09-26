//
//  Mention+CoreDataProperties.swift
//  Smashtag
//
//  Created by Ivan on 26.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData

extension Mention {

    @NSManaged var rate: NSNumber?
    @NSManaged var type: String?
    @NSManaged var value: String?
    @NSManaged var term: SearchTerm?
    @NSManaged var tweets: NSSet?

}

// MARK: Generated accessors for tweets
extension Mention {

    @objc(addTweetsObject:)
    @NSManaged func addToTweets(value: Tweet)

    @objc(removeTweetsObject:)
    @NSManaged func removeFromTweets(value: Tweet)

    @objc(addTweets:)
    @NSManaged func addToTweets(values: NSSet)

    @objc(removeTweets:)
    @NSManaged func removeFromTweets(values: NSSet)

}
