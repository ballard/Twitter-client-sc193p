//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Ivan on 19.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var unique: String?
    @NSManaged var created: NSDate?
    @NSManaged var mentions: NSSet?

    @objc(addMentionsObject:)
    @NSManaged func addToMentions(value: Mention)

    @objc(removeMentionsObject:)
    @NSManaged func removeFromMentions(value: Mention)

    @objc(addMentions:)
    @NSManaged func addToMentions(values: NSSet)

    @objc(removeMentions:)
    @NSManaged func removeFromMentions(values: NSSet)

}
