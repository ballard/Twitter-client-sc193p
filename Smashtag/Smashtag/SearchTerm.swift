//
//  SearchTerm.swift
//  Smashtag
//
//  Created by Ivan on 07.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData


class SearchTerm: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func searchTermWithSearchTermInfo(searchTermInfo: String, inManagedObjectContext context: NSManagedObjectContext) -> SearchTerm? {
        let request = NSFetchRequest(entityName: "SearchTerm")
        request.predicate = NSPredicate(format: "value matches[c] %@", searchTermInfo)
        if let searchTerm = (try? context.executeFetchRequest(request))?.first as? SearchTerm {
            return searchTerm
        } else {
            if let searchTerm = NSEntityDescription.insertNewObjectForEntityForName("SearchTerm", inManagedObjectContext: context) as? SearchTerm {
                searchTerm.value = searchTermInfo
                return searchTerm
            }
        }
        return nil
    }
}
