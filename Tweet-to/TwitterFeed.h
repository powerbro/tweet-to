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

- (void) getUserHomeTimelineData: (void(^)(NSArray *tweetDictionary))tweetFetcher;
@end
