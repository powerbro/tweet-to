//
//  Tweet.m
//  Tweet-to
//
//  Created by shitij.c on 08/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "TweetJsonParams.h"

@implementation Tweet

// Insert code here to add functionality to your managed object subclass

+ (Tweet *)insertTweetFromDictionary:(NSDictionary *)tweetDictionary fromTimelineOfUser:(NSString *)myusername intoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSString *tweetID = [tweetDictionary valueForKeyPath:ID];
    Tweet *tweet = [Tweet fetchTweetFromDBWithTweetID:tweetID withMOC:managedObjectContext];
    
    if (tweet) {
        return tweet;
    }
    
    NSString *tweetCreatedAt  = [tweetDictionary valueForKeyPath:CREATED_AT];
    NSString *tweeterName       = [tweetDictionary valueForKeyPath:NAME];
    NSString *tweeterUsername   = [tweetDictionary valueForKeyPath:USERNAME];
    NSString *tweetText       = [tweetDictionary valueForKeyPath:TEXT];
    NSString *tweeterImageURL = [tweetDictionary valueForKeyPath:IMAGE_URL];
    
    tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:managedObjectContext];
    tweet.tweet_id = tweetID;
    tweet.text = tweetText;
    tweet.created_at = tweetCreatedAt;
    
    //Create user in whose timeline tweet appears
    User *me = [User createUserWithUsername:myusername
                                 screenName:nil
                            profileImageURL:nil
                     inManagedObjectContext:managedObjectContext];
    tweet.from_timeline = me;
    
    //Create user who wrote tweet
    User *tweetCreator = [User createUserWithUsername:tweeterUsername
                                           screenName:tweeterName
                                      profileImageURL:tweeterImageURL
                               inManagedObjectContext:managedObjectContext];
    tweet.created_by = tweetCreator;
    
    return tweet;
}

+ (Tweet *)fetchTweetFromDBWithTweetID:(NSString *)tweetID withMOC:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tweet_id == %@", tweetID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tweet_id" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return [fetchedObjects firstObject];
}

+ (void)loadTweetsFromTwitterArray:(NSArray *)tweets fromTimelineOfUser:(NSString *)myusername intoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    for (NSDictionary *tweet in tweets) {
        [Tweet insertTweetFromDictionary:tweet fromTimelineOfUser:myusername intoManagedObjectContext:managedObjectContext];
    }

    NSError *error;
    [managedObjectContext save:&error];
}

@end
