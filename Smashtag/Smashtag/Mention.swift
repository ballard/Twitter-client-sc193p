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
            
            let existingMentionsStruct = mentions.filter{fetchedMentions.map{$0.value!}.contains($0.value)}
            let newMentionsStruct = mentions.filter{!existingMentionsStruct.map{$0.value}.contains($0.value)}
            
            var existingMentionsDict : [String : [String]] = [:]
            for newmention in existingMentionsStruct {
                if let oldCount = existingMentionsDict[newmention.value] {
                    existingMentionsDict[newmention.value] = oldCount + [newmention.tweetId]
                } else {
                    existingMentionsDict[newmention.value] = [newmention.tweetId]
                }
            }
            
            var newMentionsDict : [String : [String]] = [:]
            for newmention in newMentionsStruct {
                if let oldCount = newMentionsDict[newmention.value] {
                    newMentionsDict[newmention.value] = oldCount + [newmention.tweetId]
                } else {
                    newMentionsDict[newmention.value] = [newmention.tweetId]
                }
            }
            
            print("existing mentions dictionary: \(existingMentionsDict)")
            
            for existingMention in newMentionsDict {
                for fetchedMention in fetchedMentions{
                    let registedTweets = fetchedMention.tweets!.allObjects as! [Tweet]
                    let uniques = registedTweets.map{$0.unique!}
                    for tweetId in existingMention.1 {
                        if !uniques.contains(tweetId) {
                            fetchedMention.rate! = Int(fetchedMention.rate!) + 1
                            let tweet = Tweet.tweetWithTweetInfo(tweetId, forMention: fetchedMention, inManagedObjectContext: context)
                            fetchedMention.addTweetsObject(tweet!)
                        }
                    }
                }
            }
            
            for newMention in newMentionsDict {
                if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention {
                    mention.value = newMention.0
                    mention.type = newMention.0.characters.first! == "#" ? "Hastags" : "User Mentions"
                    mention.rate = newMention.1.count
                    let searchTerm = SearchTerm.searchTermWithSearchTermInfo(searchTermInfo, inManagedObjectContext: context)
                    mention.term = searchTerm
                    for tweetId in newMention.1{
                        let tweet = Tweet.tweetWithTweetInfo(tweetId, forMention: mention, inManagedObjectContext: context)
                        mention.addTweetsObject(tweet!)
                    }
                }
            }
            
//            for existingMention in existingMentionsStruct{
//                print("existing mention value: \(existingMention.value)")
//            }
//            for newMention in newMentionsStruct{
//                print("new mention value: \(newMention.value)")
//            }
            print("existingMentions count: \(existingMentionsStruct.count), new mentions count: \(newMentionsStruct.count)")
            
        }
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        print("deleting mention \(self.value!)")
    }
}
