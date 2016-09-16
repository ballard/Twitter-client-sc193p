//
//  MentionsPopularityDocument.swift
//  Smashtag
//
//  Created by Иван Лазарев on 09.09.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit

class ManagedDocument {
    
    static let sharedInstance = ManagedDocument()
    
    var document : UIManagedDocument?
    
    init(){
        let coreDataFileManager = NSFileManager.defaultManager()
        if let coreDataFileDir = coreDataFileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
            let url = coreDataFileDir.URLByAppendingPathComponent("TwitterDocument")
            let document = UIManagedDocument(fileURL: url!)
            
            if document.documentState == .Normal {
                print("document normal")
                self.document = document
            }
            
            if document.documentState == .Closed {
                if let path = url!.path {
                    let fileExists = NSFileManager.defaultManager().fileExistsAtPath(path)
                    if fileExists {
                        print("opening document")
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                            document.openWithCompletionHandler({ (success) in
                                dispatch_async(dispatch_get_main_queue()) {
                                    print("document opened")
                                    return self.document = document
                                }
                            })
                        }
                    } else {
                        print("creating document")
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                            document.saveToURL(url!, forSaveOperation: .ForCreating, completionHandler: { (success) in
                                dispatch_async(dispatch_get_main_queue()) {
                                    print("document created")
                                    return self.document = document
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
