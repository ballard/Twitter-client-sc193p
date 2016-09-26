//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Ivan on 26.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var created: NSDate?
    @NSManaged var unique: String?
    @NSManaged var mentions: NSSet?
    @NSManaged var term: SearchTerm?

}

// MARK: Generated accessors for mentions
extension Tweet {

    @objc(addMentionsObject:)
    @NSManaged func addToMentions(value: Mention)

    @objc(removeMentionsObject:)
    @NSManaged func removeFromMentions(value: Mention)

    @objc(addMentions:)
    @NSManaged func addToMentions(values: NSSet)

    @objc(removeMentions:)
    @NSManaged func removeFromMentions(values: NSSet)

}
