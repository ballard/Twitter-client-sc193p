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
    
    struct MentionPayload {
        var value : String
        var tweetId : String // todo unique mention values with tweet id array
    }
    
// Insert code here to add functionality to your managed object subclass
    
    class func mentionsWithTweetsInfo(tweetsInfo: [Twitter.Tweet], forSearchTermInfo searchTermInfo: String, inManagedObjectContext context: NSManagedObjectContext) {
        
        let hashtags = tweetsInfo.flatMap { (Tweet) in
            Tweet.hashtags.map{ MentionPayload(value: $0.keyword.lowercaseString, tweetId: Tweet.id) }
        }
        let userMentions = tweetsInfo.flatMap { (Tweet) in
            Tweet.userMentions.map{ MentionPayload(value: $0.keyword.lowercaseString, tweetId: Tweet.id) }
        }
        let mentions = hashtags + userMentions
        let mentionsValues = (hashtags + userMentions).map {$0.value}
        
        let request = NSFetchRequest(entityName: "Mention")
        request.predicate = NSPredicate(format: "value in %@ and term.value = %@", mentionsValues, searchTermInfo)
        
        if let fetchedMentions = (try? context.executeFetchRequest(request)) as? [Mention] {
            
            let existingMentions = mentions.filter{fetchedMentions.map{$0.value!}.contains($0.value)}
            let newMentions = mentions.filter{!existingMentions.map{$0.value}.contains($0.value)}
            
            for existingMention in Mention.fillMentionsDictWithMentionPayload(existingMentions) {
                for fetchedMention in fetchedMentions{
                    if fetchedMention.value == existingMention.0 {
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
            }
            
            for newMention in Mention.fillMentionsDictWithMentionPayload(newMentions) {
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
            print("existingMentions count: \(existingMentions.count), new mentions count: \(newMentions.count)")
            
        }
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        print("deleting mention \(self.value!)")
    }
}
