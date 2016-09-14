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

struct MentionPayload {
    var value : String
    var tweetId : String // todo unique mention values with tweet id array
}

class Mention: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func mentionsWithTweetsInfo(tweetsInfo: [Twitter.Tweet], forSearchTermInfo searchTermInfo: String, inManagedObjectContext context: NSManagedObjectContext) {
        
        let hashtags = tweetsInfo.flatMap { (Tweet) in
            Tweet.hashtags.map{ MentionPayload(value: $0.keyword.lowercaseString, tweetId: Tweet.id) }
        }
        let userMentions = tweetsInfo.flatMap { (Tweet) in
            Tweet.userMentions.map{ MentionPayload(value: $0.keyword.lowercaseString, tweetId: Tweet.id) }
        }
        let mentions = hashtags + userMentions
        let mentionsValues = mentions.map {$0.value}
        
        let request = NSFetchRequest(entityName: "Mention")
        request.predicate = NSPredicate(format: "value in %@ and term.value = %@", mentionsValues, searchTermInfo)
        
        if let fetchedMentions = (try? context.executeFetchRequest(request)) as? [Mention] {
            
//            let fetchedMentionsValues = fetchedMentions.map{$0.value!}
            
            let existingMentionsStruct = mentions.filter{fetchedMentions.map{$0.value!}.contains($0.value)}
            let newMentionsStruct = mentions.filter{!existingMentionsStruct.map{$0.value}.contains($0.value)}
            
            
            
            
//            let existingMentions = mentionsValues.filter{fetchedMentions.map{$0.value!}.contains($0)}
//            let newMentions = mentionsValues.filter{!existingMentions.contains($0)}
            
//            for fetchedMention in fetchedMentions {
//                let registedTweets = fetchedMention.tweets!.allObjects as! [Tweet]
//                let uniques = registedTweets.map{$0.unique!}
//                
//                for existingMention in existingMentionsStruct {
//                    if !uniques.contains(existingMention.tweetId) {
//                        fetchedMention.rate! = Int(fetchedMention.rate!) + 1
//                        let tweet = Tweet.tweetWithTweetInfo(existingMention.tweetId, forMention: fetchedMention, inManagedObjectContext: context)
//                        fetchedMention.addTweetsObject(tweet!)
//                    }
//                    
//                }
//            }
//            
//            for newMention in newMentionsStruct {
//                if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention {
//                    mention.value = newMention.value
//                    mention.type = newMention.value.characters.first == "#" ? "Hastags" : "User Mentions"
//                    mention.rate = 1
//                    let searchTerm = SearchTerm.searchTermWithSearchTermInfo(searchTermInfo, inManagedObjectContext: context)
//                    mention.term = searchTerm
//                    let tweet = Tweet.tweetWithTweetInfo(newMention.tweetId, forMention: mention, inManagedObjectContext: context)
//                    mention.addTweetsObject(tweet!)
//                }
//            }
            
            for existingMention in existingMentionsStruct{
                print("existing mention value: \(existingMention.value)")
            }
            for newMention in newMentionsStruct{
                print("new mention value: \(newMention.value)")
            }
            print("existingMentions count: \(existingMentionsStruct.count), new mentions count: \(newMentionsStruct.count)")
            
        }
        
        
        
        
//        if let mentions = (try? context.executeFetchRequest(request)) as? [Mention] {
//            let existingMentions = mentionInfoValues.filter{ mentions.map{ $0.value! }.contains($0) }
//            print("existingMentions count: \(mentions.count)")
//            
//            for mention in mentions {
//                for existingMention in existingMentions {
//                    if mention.value == existingMention {
//                        mention.rate = Int(mention.rate!) + mentionsInfo[mention.value!]!
//                    }
//                }
//            }
//
//            let newMentions = mentionInfoValues.filter { !existingMentions.contains($0) }
//            print("newMentions count: \(newMentions.count)")
//            
//            for newMention in newMentions {
//                if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention {
//                    mention.value = newMention
//                    mention.type = newMention.characters.first! == "#" ? "Hashtags" : "User Mentions"
//                    mention.rate = mentionsInfo[mention.value!]!
//                    let searchTerm = SearchTerm.searchTermWithSearchTermInfo(searchTermInfo, inManagedObjectContext: context)
//                    mention.term = searchTerm
//                }
//            }

//            print("fetched mensions count: \(mentionsInfo.count)")
        
    }
    
    
    class func mentionWithMentionInfo(mentionInfo: String, withMentionType mentionType: String, forSearchTermInfo searchTermInfo: String, forTweetInfo tweetInfo: String, inManagedObjectContext context: NSManagedObjectContext) -> Mention? {
        let request = NSFetchRequest(entityName: "Mention")
        request.predicate = NSPredicate(format: "value = %@ and term.value = %@", mentionInfo, searchTermInfo)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? Mention {
            let registedTweets = mention.tweets!.allObjects as! [Tweet]
            let uniques = registedTweets.map{$0.unique!}
            if uniques.contains(tweetInfo) == false {
                mention.rate! = Int(mention.rate!) + 1
                let tweet = Tweet.tweetWithTweetInfo(tweetInfo, forMention: mention, inManagedObjectContext: context)
                mention.addTweetsObject(tweet!)
                return mention
            }
        } else {
            if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention {
                mention.value = mentionInfo
                mention.type = mentionType
                mention.rate = 1
                let searchTerm = SearchTerm.searchTermWithSearchTermInfo(searchTermInfo, inManagedObjectContext: context)
                mention.term = searchTerm
                let tweet = Tweet.tweetWithTweetInfo(tweetInfo, forMention: mention, inManagedObjectContext: context)
                mention.addTweetsObject(tweet!)
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
