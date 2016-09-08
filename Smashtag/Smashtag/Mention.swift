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

// Insert code here to add functionality to your managed object subclass
    
    
    class func mentionWithMentionInfo(mentionInfo: Twitter.Mention, withMentionType mentionType: String, inManagedObjectContext context: NSManagedObjectContext) -> Mention? {
        
        let request = NSFetchRequest(entityName: "Mention")
        request.predicate = NSPredicate(format: "value = %@", mentionInfo.keyword)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? Mention {
            var mentionRate = Int(mention.rate!)
            mentionRate += 1
            mention.rate! = mentionRate
//            print("mention tweets: \(mention.tweets)")
            return mention
        } else {
            if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention{
                mention.value = mentionInfo.keyword
                mention.type = mentionType
                mention.rate = 1
//                print("mention tweets: \(mention.tweets)")
                return mention
            }
        }
        
        return nil
        
    }

}
