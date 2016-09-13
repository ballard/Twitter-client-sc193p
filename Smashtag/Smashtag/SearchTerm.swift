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
    
    class func searchTermWithSearchTermInfo(searchTermInfo: String, forMension mension: String, inManagedObjectContext context: NSManagedObjectContext) -> SearchTerm? {
        let request = NSFetchRequest(entityName: "SearchTerm")
        request.predicate = NSPredicate(format: "value = %@ and mension.value = mension", searchTermInfo)
        if let searchTerm = (try? context.executeFetchRequest(request))?.first as? SearchTerm {
            var searchTermCount = Int(searchTerm.count!)
            searchTermCount += 1
            searchTerm.count! = searchTermCount
            return searchTerm
        } else {
            if let searchTerm = NSEntityDescription.insertNewObjectForEntityForName("SearchTerm", inManagedObjectContext: context) as? SearchTerm {
                searchTerm.value = searchTermInfo
                searchTerm.count = 1
                return searchTerm
            }
        }
        return nil
    }
}
