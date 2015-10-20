//
//  Authorization.m
//  Tweet-to
//
//  Created by shitij.c on 09/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "Authorization.h"

@interface Authorization()

#pragma Authorization: OAuth parameters

@property (strong, nonatomic) NSString *oauth_consumer_key;
@property (strong, nonatomic) NSString *oauth_nonce;
@property (strong, nonatomic) NSString *oauth_signature;
@property (strong, nonatomic) NSString *oauth_signature_method;
@property (strong, nonatomic) NSString *oauth_timestamp;
@property (strong, nonatomic) NSString *oauth_token;
@property (strong, nonatomic) const NSString *oauth_version;

@end

@implementation Authorization


- (NSString *)getAuthorizationHeader
{
    return nil;
}


@end
