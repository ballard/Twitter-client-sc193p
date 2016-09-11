//
//  Mention.swift
//  Smashtag
//
//  Created by Ivan on 07.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData

class Mention: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    
    class func mentionWithMentionInfo(mentionInfo: String, withMentionType mentionType: String, forSearchTermInfo searchTermInfo: String, inManagedObjectContext context: NSManagedObjectContext) -> Mention? {
        
        let request = NSFetchRequest(entityName: "Mention")
        request.predicate = NSPredicate(format: "value = %@ and term.value = %@", mentionInfo, searchTermInfo)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? Mention {
            var mentionRate = Int(mention.rate!)
            mentionRate += 1
            mention.rate! = mentionRate
            return mention
        } else {
            if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention{
                mention.value = mentionInfo
                mention.type = mentionType
                mention.rate = 1
//                print("searh term info: \(searchTermInfo)")
                let searchTerm = SearchTerm.searchTermWithSearchTermInfo(searchTermInfo, inManagedObjectContext: context)
                mention.term = searchTerm
//                print("recorded mention: \(mention)")
                return mention
            }
        }
        
        return nil
        
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        print("deleting mention \(self.value!)")
    }
}
