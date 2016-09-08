//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Иван Лазарев on 07.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var created: NSDate?
    @NSManaged var text: String?
    @NSManaged var unique: String?
    @NSManaged var mentions: NSSet?
    @NSManaged var searchTerms: NSSet?
    
    @NSManaged func addMentionsObject(mension: Mention)
    @NSManaged func addMentions(mensions: NSSet)
    
    @NSManaged func addSearchTermsObject(searchTerm: SearchTerm)
    @NSManaged func addSearchTerms(searchTerms: NSSet)

}
