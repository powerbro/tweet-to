//
//  Authorization.m
//  Tweet-to
//
//  Created by shitij.c on 09/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "Authorization.h"
#import "ConsumerTokens.h"
#import "NSString+TwitterEncode.h"

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

@interface Authorization()

#pragma Authorization: OAuth parameters

@property (strong, nonatomic, readonly) NSString *oauthConsumerKey;
@property (strong, nonatomic, readonly) NSString *oauthConsumerSecret;


@property (strong, nonatomic, readonly) NSString *oauthNonce;
@property (strong, nonatomic, readonly) NSString *oauthSignatureMethod;
@property (strong, nonatomic, readonly) NSString *oauthTimestamp;
@property (strong, nonatomic, readonly) NSString *oauthVersion;

@property (strong, nonatomic, readonly) NSString *oauthSignature;

// set in init
@property (strong, nonatomic) NSDictionary *httpRequestParameters;
@property (strong, nonatomic) NSString *baseRequestURL;
@property (strong, nonatomic) NSString *httpRequestMethod;

@property (strong, nonatomic) NSString *oauthToken;
@property (strong, nonatomic) NSString *oauthTokenSecret;

@property (strong, nonatomic) NSDictionary *oauthParametersWITHOauthSignature;
@property (strong, nonatomic) NSDictionary *oauthParametersWITHOUTOauthSignature;

@end

@implementation Authorization


- (instancetype)init
{
    //NSUserDefault values set at application launch time
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.userID = [userDefaults stringForKey:@"user_id"];
    self.username = [userDefaults stringForKey:@"screen_name"];
    self.oauthToken = [userDefaults stringForKey:@"oauth_token"];
    self.oauthTokenSecret = [userDefaults stringForKey:@"oauth_token_secret"];

    return self;
}


- (void) initWithURL: (NSString *)URL httpMethod:(NSString *)httpMethod parameters: (NSDictionary *)httpParameters
{
    
    self.baseRequestURL = URL;
    self.httpRequestMethod = httpMethod;
    self.httpRequestParameters = httpParameters;

    NSMutableDictionary *oauthParametersWithoutSignature = [[NSMutableDictionary alloc] init];
    [oauthParametersWithoutSignature setObject:self.oauthConsumerKey     forKey:@"oauth_consumer_key"];
    [oauthParametersWithoutSignature setObject:self.oauthNonce           forKey:@"oauth_nonce"];
    [oauthParametersWithoutSignature setObject:self.oauthSignatureMethod forKey:@"oauth_signature_method"];
    [oauthParametersWithoutSignature setObject:self.oauthTimestamp       forKey:@"oauth_timestamp"];
    [oauthParametersWithoutSignature setObject:self.oauthToken           forKey:@"oauth_token"];
    [oauthParametersWithoutSignature setObject:self.oauthVersion         forKey:@"oauth_version"];
    self.oauthParametersWITHOUTOauthSignature = oauthParametersWithoutSignature;

    NSMutableDictionary *oauthParametersWithSignature = [NSMutableDictionary dictionaryWithDictionary:oauthParametersWithoutSignature];
    [oauthParametersWithSignature setObject:self.oauthSignature forKey:@"oauth_signature"];
    
    self.oauthParametersWITHOauthSignature = oauthParametersWithSignature;
}

- (NSString *)getAuthorizationHeader: (NSString *)URL httpMethod:(NSString *)httpMethod parameters: (NSDictionary *)httpParameters
{

    [self initWithURL:URL httpMethod:httpMethod parameters:httpParameters];

    NSMutableString *authorizationHeader = [NSMutableString stringWithString:@"OAuth "];

    NSArray *sortedKeys = [[self.oauthParametersWITHOauthSignature allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *headerStringWithEncodedParameters = [[NSMutableString alloc] init];

    for (NSString *key in sortedKeys) {
        NSString *encodedKey = [key stringByTwitterEncodingString];
        
        NSString *encodedValue = [[self.oauthParametersWITHOauthSignature objectForKey:key] stringByTwitterEncodingString];
        NSString *queryParams = [NSString stringWithFormat:@"%@=\"%@\", ", encodedKey, encodedValue];
        [headerStringWithEncodedParameters appendString:queryParams];
    }
    NSUInteger trailingLength = [headerStringWithEncodedParameters length]-2; //remove trailing ',' and 'space'
    [authorizationHeader appendString:[headerStringWithEncodedParameters substringToIndex:trailingLength]];

    return authorizationHeader;
}

- (NSString *)oauthNonce
{
    unsigned int maxStringLength = 32;
    NSString *alphaNumericString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:maxStringLength];
    for (int i = 0; i < maxStringLength; i++) {
        unsigned int randomIndex =  arc4random_uniform((unsigned)[alphaNumericString length]);
        [randomString appendFormat:@"%C", [alphaNumericString characterAtIndex: randomIndex]];
    }
    return randomString;
}

- (NSString *)oauthSignatureMethod
{
    return @"HMAC-SHA1";
}

- (NSString *)oauthTimestamp
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[[NSDate date] timeIntervalSince1970]];
}

- (NSString *)oauthVersion
{
    return @"1.0";
}


- (NSString *)oauthConsumerKey
{
    return CONSUMER_KEY;
}

- (NSString *)oauthConsumerSecret
{
    return CONSUMER_KEY_SECRET;
}

- (NSString *)oauthSignature
{
    NSMutableDictionary *completeParameters = [NSMutableDictionary dictionaryWithDictionary:self.httpRequestParameters];
    [completeParameters addEntriesFromDictionary:self.oauthParametersWITHOUTOauthSignature];
    
    //Encode parameters
    NSMutableDictionary *encodedParameters = [NSMutableDictionary dictionaryWithCapacity:[completeParameters count]];
    for (NSString *key in completeParameters) {
        NSString *value = [completeParameters objectForKey:key];
        
        NSString *encodedKey = [key stringByTwitterEncodingString];
        NSString *encodedValue = [value stringByTwitterEncodingString];
        [encodedParameters setObject:encodedValue forKey:encodedKey];
    }
    
    //Sort parameters and create parameter string
    NSArray *sortedKeys = [[encodedParameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *stringWithEncodedParameters = [[NSMutableString alloc] init];
    for (NSString *key in sortedKeys) {
        NSString *value = [encodedParameters objectForKey:key];
        
        NSString *queryParams = [NSString stringWithFormat:@"%@=%@&", key, value];
        [stringWithEncodedParameters appendString:queryParams];
    }
    NSUInteger trailingLength = [stringWithEncodedParameters length]-1; //remove trailing '&'
    
    NSString *parameterString = [stringWithEncodedParameters substringToIndex:trailingLength];
    NSString *httpMethod = self.httpRequestMethod;
    NSString *baseURL = self.baseRequestURL;
    
    //Create base signature string
    NSString *encodedBaseURL = [baseURL stringByTwitterEncodingString];
    NSString *encodedParameterString = [parameterString stringByTwitterEncodingString];

    NSMutableString *baseSignature = [NSMutableString stringWithString:[httpMethod uppercaseString]];
    [baseSignature appendString:@"&"];
    [baseSignature appendString:encodedBaseURL];
    [baseSignature appendString:@"&"];
    [baseSignature appendString:encodedParameterString];
    
    //Create signing key
    NSString *encodedConsumerSecret = [self.oauthConsumerSecret stringByTwitterEncodingString];
    NSString *encodedOauthTokenSecret = [self.oauthTokenSecret stringByTwitterEncodingString];
    
    NSMutableString *signingKey = [NSMutableString stringWithString:encodedConsumerSecret];
    [signingKey appendString:@"&"];
    [signingKey appendString:encodedOauthTokenSecret];
    
    //Create oauth signature HMAC - SHA1
    const char *signingKeyData = [signingKey UTF8String];
    const char *baseSignatureData = [baseSignature UTF8String];
    
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, signingKeyData, strlen(signingKeyData), baseSignatureData, strlen(baseSignatureData), buf);
    NSData *base64Data = [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
    NSString *oauthSignature = [base64Data base64EncodedStringWithOptions:kNilOptions];
    
    return oauthSignature;
}

@end
