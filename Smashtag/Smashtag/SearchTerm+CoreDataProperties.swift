//
//  SearchTerm+CoreDataProperties.swift
//  Smashtag
//
//  Created by Ivan on 11.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SearchTerm {

    @NSManaged var value: String?
    @NSManaged var mensions: NSSet?

}
