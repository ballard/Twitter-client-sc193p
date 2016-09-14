//
//  Tweet+CoreDataProperties.swift
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

extension Tweet {

    @NSManaged var unique: String?
    @NSManaged var mentions: NSSet?
    
    @NSManaged func addMentionsObject(mention: Mention)
    @NSManaged func addMentions(mentions: NSSet)

}
