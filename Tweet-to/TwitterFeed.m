//
//  TwitterFeed.m
//  Tweet-to
//
//  Created by shitij.c on 07/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "TwitterFeed.h"
#import "Authorization.h"
#import "NSString+TwitterEncode.h"

@import Accounts;
@import Social;

@interface TwitterFeed()
@property (strong, nonatomic) Authorization *authorize;

@end

@implementation TwitterFeed

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authorize = [[Authorization alloc] init];
    }
    return self;
}

- (void) performSLRequestForTwitterAccount:(NSString *)HTTPRequestType withURL:(NSURL *)url withParameters: (NSDictionary *)parameters result:(void(^)(id response))responseHandler
{
        NSString *authorizationHeader = [self.authorize getAuthorizationHeader:[url absoluteString]
                                                                httpMethod:HTTPRequestType
                                                                parameters:parameters];
    
        NSMutableString *baseURL = [NSMutableString stringWithString:[url absoluteString]];
        if ([parameters count]) {
            [baseURL appendString:@"?"];
            for (NSString *key in parameters) {
                NSString *value = [parameters objectForKey:key];
                [baseURL appendString:[key stringByTwitterEncodingString]];
                [baseURL appendString:@"="];
                [baseURL appendString:[value stringByTwitterEncodingString]];
                [baseURL appendString:@"&"];
            }
            NSUInteger trailingLength = [baseURL length]-1; //remove trailing '&'
            [baseURL setString:[baseURL substringToIndex:trailingLength]];
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
        
        [request setHTTPMethod:HTTPRequestType];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
        
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable urlResponse, NSError * _Nullable error) {
            
            NSInteger responseCode = [(NSHTTPURLResponse*)urlResponse statusCode];
            NSLog(@"HTTP response code: %ld", responseCode);
            //NSLog(@"HTTP response: %@", urlResponse);
            //NSLog(@"Error: %@", error);
            
            NSData *responseData = [NSData dataWithContentsOfURL:location];
            id jsonResponse = nil;
            if(responseData && responseCode == 200) {
                jsonResponse = (id)[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:NULL];
            }
            if(responseHandler) //is not nil
                responseHandler(jsonResponse);
        }];
        
        [downloadTask resume];
}

- (void)getUsernameOnInitialization:(void (^)(NSString *))fetchUsername
{
    [self.authorize getUserDetails:^(NSString *username, NSString *userID) {
        fetchUsername(username);
    }];
}

#pragma mark - GET methods

- (void) getUserHomeTimelineData: (void(^)(NSArray *tweets))tweetFetcher
{
    NSURL *homeTimelineURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSDictionary *parameters = @{@"count" : @"50"};
    
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


- (void)getFollowersList:(NSString *)username withCompletionHandler: (void(^)(NSArray *followerList)) fetchFollowerList
{
    NSURL *followerListURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
    NSDictionary *parameters = @{@"screen_name" : username, @"count": @"50"};
    
    [self performSLRequestForTwitterAccount:@"GET" withURL: followerListURL withParameters:parameters result:^(id response) {
        NSArray *followerDataArray = response;
        NSArray *followerArray = [followerDataArray valueForKeyPath:@"users"];
        fetchFollowerList(followerArray);
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


