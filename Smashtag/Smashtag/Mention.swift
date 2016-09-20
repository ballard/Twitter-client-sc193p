//
//  Mention.swift
//  Smashtag
//
//  Created by Ivan on 07.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class Mention: NSManagedObject {
    
    class func mentionWithMentionInfo(mentionInfo: String, withMentionType mentionType: String, forSearchTermInfo searchTermInfo: String, inManagedObjectContext context: NSManagedObjectContext) -> Mention? {
        
        let request = NSFetchRequest(entityName: "Mention")
        request.predicate = NSPredicate(format: "value = %@ and term.value = %@", mentionInfo, searchTermInfo.lowercaseString, tweetInfo)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? Mention {
            mention.rate! = Int(mention.rate!) + 1
            return mention
        } else {
            if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention{
                mention.value = mentionInfo
                mention.type = mentionType
                mention.rate = 1
                let searchTerm = SearchTerm.searchTermWithSearchTermInfo(searchTermInfo.lowercaseString, inManagedObjectContext: context)
                mention.term = searchTerm
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
