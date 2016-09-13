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
        request.predicate = NSPredicate(format: "value = %@", mentionInfo)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? Mention {
            return mention
        } else {
            if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention {
                mention.value = mentionInfo
                mention.type = mentionType
                let searchTerm = SearchTerm.searchTermWithSearchTermInfo(searchTermInfo, forMension: mention.value!, inManagedObjectContext: context)
                mention.addTermsObject(searchTerm!)
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
