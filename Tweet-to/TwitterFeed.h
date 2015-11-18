//
//  TwitterFeed.h
//  Tweet-to
//
//  Created by shitij.c on 07/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <Foundation/Foundation.h>

//#warning To-Do : Change to use Oauth and NSURL with HMAC signing

@interface TwitterFeed : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userID;


- (void) getHomeTimelineData: (void(^)(NSArray *tweetDictionary))tweetFetcher;

- (void) getUserData:(NSString *)userName withCompletionHandler:(void(^)(NSDictionary *userData))userDataFetcher;

- (void) getLastPostedTweetsForUser: (NSString *)userName tweetCount:(NSInteger)count withCompletionHandler:(void(^)(NSArray *tweets))tweetFetcher;

- (void)getFollowersList:(NSString *)username withCompletionHandler: (void(^)(NSArray *followerList)) fetchFollowerList;

- (void) postTweet:(NSString *)tweet;

@end
