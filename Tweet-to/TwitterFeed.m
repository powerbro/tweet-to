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
@end

@implementation TwitterFeed

/*
- (NSString *)getHomeTwitterAccountUsername;
{
    return self.twitterAccount.username;
}
*/


//- (void) performSLRequestForTwitterAccount: (NSURL *)url withParameters: (NSDictionary *)parameters result:(void(^)(id))response
//{
//    
//    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
//    ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:
//                                         ACAccountTypeIdentifierTwitter];
//    
//    [accountStore requestAccessToAccountsWithType:accountTypeTwitter
//                                          options:nil
//                                       completion:^(BOOL granted, NSError *error) {
//                                           
//           if(granted) {
//               
//                ACAccount *twitterAccount = [[accountStore accountsWithAccountType:
//                                                 accountTypeTwitter] lastObject];
//
//                SLRequest *GETRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
//                                                          requestMethod:SLRequestMethodGET
//                                                                    URL:url
//                                                             parameters:parameters];
//                GETRequest.account = twitterAccount;
//                [GETRequest performRequestWithHandler:^(NSData *responseData,
//                                                       NSHTTPURLResponse *urlResponse,
//                                                       NSError *error) {
//
//                   //NSLog(@"HTTP response: %li", [urlResponse statusCode]);
//                   //NSLog(@"Response body: \n%@", self.tweets);
//                    response(responseData);
//                }];
//           }
//           else {
//                NSLog(@"Error: Access to twitter account denied");
//           }
//            
//    }];
//}
//


- (void)getUsernameFromACAccount:(void (^)(NSString *username))fetchUsername
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
           fetchUsername(twitterAccount.username);
       }
       else {
           NSLog(@"Access denied");
           fetchUsername(nil);
       }
   }];
}

- (void) performSLRequestForTwitterAccount:(NSString *)HTTPRequestType withURL:(NSURL *)url withParameters: (NSDictionary *)parameters result:(void(^)(id response))responseHandler
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

                SLRequestMethod httpRequestType;

                if([HTTPRequestType isEqualToString:@"GET"]) {
                    httpRequestType = SLRequestMethodGET;
                }
                else if([HTTPRequestType isEqualToString:@"POST"]) {
                    httpRequestType = SLRequestMethodPOST;
                }

                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                      requestMethod:httpRequestType
                                                                URL:url
                                                         parameters:parameters];
                request.account = twitterAccount;
                [request performRequestWithHandler:^(NSData *responseData,
                                                   NSHTTPURLResponse *urlResponse,
                                                   NSError *error) {
                    //NSLog(@"HTTP response: %li", [urlResponse statusCode]);
                    id jsonResponse = nil;
                    if(responseData) {
                        jsonResponse = (id)[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:NULL];
                    }
                    
                    if(responseHandler) //is not nil
                        responseHandler(jsonResponse);
                }];
           }
           else
           {
               NSLog(@"Error: Access to twitter account denied");
           }

    }];
}

#pragma mark - GET methods

- (void) getUserHomeTimelineData: (void(^)(NSArray *tweets))tweetFetcher
{
    NSURL *homeTimelineURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSDictionary *parameters = @{@"count" : @"20"};
    
    [self performSLRequestForTwitterAccount:@"GET" withURL:homeTimelineURL withParameters:parameters result:^(id response) {
        NSArray *tweets = response;
        tweetFetcher(tweets);
    }];
}

- (void) getUserTimelineData: (NSString *)userName tweetCount:(NSInteger)count withCompletionHandler:(void(^)(NSArray *tweets))tweetFetcher
{
    NSURL* userTimelineURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
    NSDictionary *parameters = @{@"screen_name": userName, @"count" : [@(count) stringValue]};
    
    [self performSLRequestForTwitterAccount:@"GET" withURL:userTimelineURL withParameters:parameters result:^(id response) {
        NSArray *tweets = response;
        tweetFetcher(tweets);
    }];
}


- (void)getUserData:(NSString *)userName withCompletionHandler:(void(^)(NSDictionary *userData))userDataFetcher
{
    NSURL *userDataURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
    NSDictionary *parameters = @{@"screen_name" : userName};
    
    [self performSLRequestForTwitterAccount:@"GET" withURL:userDataURL withParameters:parameters result:^(id response) {
        NSDictionary *userData = response;
        userDataFetcher(userData);
    }];
}
                  

#pragma mark - POST methods

- (void) postTweet:(NSString *)tweet
{
    NSURL *postTweetURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
    NSDictionary *parameters = @{@"status" : tweet};
    
    [self performSLRequestForTwitterAccount:@"POST" withURL:postTweetURL withParameters:parameters result:nil];
}

@end
