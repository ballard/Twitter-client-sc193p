//
//  Mention+CoreDataProperties.swift
//  Smashtag
//
//  Created by Ivan on 19.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import Foundation
import CoreData

extension Mention {

    @NSManaged var rate: NSNumber?
    @NSManaged var type: String?
    @NSManaged var value: String?
    @NSManaged var term: SearchTerm?
    @NSManaged var tweet: Tweet?

}
