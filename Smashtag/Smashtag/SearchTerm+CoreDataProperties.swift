//
//  SearchTerm+CoreDataProperties.swift
//  Smashtag
//
//  Created by Ivan on 26.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData

extension SearchTerm {

    @NSManaged var value: String?
    @NSManaged var mensions: NSSet?
    @NSManaged var tweets: NSSet?

}

// MARK: Generated accessors for mensions
extension SearchTerm {

    @objc(addMensionsObject:)
    @NSManaged func addToMensions(value: Mention)

    @objc(removeMensionsObject:)
    @NSManaged func removeFromMensions(value: Mention)

    @objc(addMensions:)
    @NSManaged func addToMensions(values: NSSet)

    @objc(removeMensions:)
    @NSManaged func removeFromMensions(values: NSSet)

}

// MARK: Generated accessors for tweets
extension SearchTerm {

    @objc(addTweetsObject:)
    @NSManaged func addToTweets(value: Tweet)

    @objc(removeTweetsObject:)
    @NSManaged func removeFromTweets(value: Tweet)

    @objc(addTweets:)
    @NSManaged func addToTweets(values: NSSet)

    @objc(removeTweets:)
    @NSManaged func removeFromTweets(values: NSSet)

}
