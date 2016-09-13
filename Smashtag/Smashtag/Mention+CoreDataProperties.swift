//
//  Mention+CoreDataProperties.swift
//  Smashtag
//
//  Created by Ivan on 13.09.16.
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
}
