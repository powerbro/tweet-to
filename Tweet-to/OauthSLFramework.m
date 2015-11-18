//
//  OauthSLFramework.m
//  Tweet-to
//
//  Created by shitij.c on 03/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

@import Social;
@import Accounts;

#import "OauthSLFramework.h"
#import "ConsumerTokens.h"

@implementation OauthSLFramework

- (void)getUserAccessTokensFromACAccount:(void (^)(NSDictionary *userAccessTokens))fetchAccessTokenDict
{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountTypeTwitter options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            ACAccount *twitterAccount = [[accountStore accountsWithAccountType: accountTypeTwitter] lastObject];

            [self requestTokenForReverseOauthAccount:twitterAccount withCompletionHandler:^(id response) {
                
                NSString *oauthSignatureString = response;
                [self requestAccessToken:twitterAccount withSignature:oauthSignatureString withCompletionHandler:^(id response) {
                    NSString *accessTokens = response;
                    //NSLog(@"Access Tokens : %@",accessTokens);
                    
                    NSMutableDictionary *queryStringDictionary = nil;
                    if (accessTokens) {
                        queryStringDictionary= [[NSMutableDictionary alloc] init];
                        NSArray *urlParts = [accessTokens componentsSeparatedByString:@"&"];
                        for (NSString *keyValuePair in urlParts) {
                            NSArray *pair = [keyValuePair componentsSeparatedByString:@"="];
                            
                            NSString *key = [[pair firstObject] stringByRemovingPercentEncoding];
                            NSString *value = [[pair lastObject] stringByRemovingPercentEncoding];
                            [queryStringDictionary setObject:value forKey:key];
                        }
                    }
                    
                    fetchAccessTokenDict(queryStringDictionary);
                }];
            }];
        }
        else {
            NSLog(@"Access denied");
        }
    }];
}

- (void) requestTokenForReverseOauthAccount:(ACAccount *) twitterAccount withCompletionHandler: (void (^)(id response))fetchOauthSignature
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    NSDictionary *parameters = @{@"x_auth_mode": @"reverse_auth"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters: parameters];
    
    request.account = twitterAccount;
    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        NSString *reverseAuthSignature = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", reverseAuthSignature);
        fetchOauthSignature(reverseAuthSignature);
    }];
    
}

- (void) requestAccessToken:(ACAccount *) twitterAccount withSignature:(NSString *)oauthSignature withCompletionHandler: (void (^)(id response))fetchAccessTokens
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    NSDictionary *parameters = @{@"x_reverse_auth_target" : CONSUMER_KEY, @"x_reverse_auth_parameters" : oauthSignature};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:parameters];
    
    request.account = twitterAccount;
    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        
        NSString *accessTokens = nil;
        if(data)
            accessTokens = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        fetchAccessTokens(accessTokens);
    }];
}


@end
