//
//  TwitterFeed.m
//  Tweet-to
//
//  Created by shitij.c on 07/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "TwitterFeed.h"

@import Accounts;
@import Social;

@interface TwitterFeed()
@property (strong, nonatomic) NSArray *tweets;
@end

@implementation TwitterFeed

- (void) getUserHomeTimelineData: (void(^)(NSArray *tweets))tweetFetcher
{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:
                                         ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountTypeTwitter
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
                                           
               if(granted) {
    
                   ACAccount *twitterAccount = [[accountStore accountsWithAccountType:
                                                 accountTypeTwitter] lastObject];
                   
                   NSURL *homeTimelineURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                   NSDictionary *parametersHT = @{@"count" : @"20"};
                   
                   SLRequest *GETRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                              requestMethod:SLRequestMethodGET
                                                                        URL:homeTimelineURL
                                                                 parameters:parametersHT];
                   GETRequest.account = twitterAccount;
                   [GETRequest performRequestWithHandler:^(NSData *responseData,
                                                           NSHTTPURLResponse *urlResponse,
                                                           NSError *error){
                       
                    self.tweets = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                  options:kNilOptions
                                                                                    error:NULL];
                    //NSLog(@"HTTP response: %li", [urlResponse statusCode]);
                    //NSLog(@"Response body: \n%@", self.tweets);
                       
                    tweetFetcher(self.tweets);
                   }];
               }
           }];
    
}


@end
