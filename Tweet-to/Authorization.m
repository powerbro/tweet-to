//
//  Authorization.m
//  Tweet-to
//
//  Created by shitij.c on 09/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "Authorization.h"
#import "ConsumerTokens.h"
#import "OauthSLFramework.h"
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

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userID;

@end

@implementation Authorization

//- (instancetype)init
//{
//    OauthSLFramework *oauthFromACAccount = [[OauthSLFramework alloc] init];
//    [oauthFromACAccount getUserAccessTokensFromACAccount:^(NSDictionary *userAccessTokens) {
//            self.userID = [userAccessTokens           objectForKey:@"user_id"];
//            self.username = [userAccessTokens         objectForKey:@"screen_name"];
//            self.oauthToken = [userAccessTokens       objectForKey:@"oauth_token"];
//            self.oauthTokenSecret = [userAccessTokens objectForKey:@"oauth_token_secret"];
//    }];
//
//    return self;
//}

- (void)initialize: (void(^)(void))onCompletion
{
    OauthSLFramework *oauthFromACAccount = [[OauthSLFramework alloc] init];
    [oauthFromACAccount getUserAccessTokensFromACAccount:^(NSDictionary *userAccessTokens) {
            self.userID = [userAccessTokens           objectForKey:@"user_id"];
            self.username = [userAccessTokens         objectForKey:@"screen_name"];
            self.oauthToken = [userAccessTokens       objectForKey:@"oauth_token"];
            self.oauthTokenSecret = [userAccessTokens objectForKey:@"oauth_token_secret"];
        NSLog(@"\nusername : %@", self.username);
        NSLog(@"\nusername dict: %@", [userAccessTokens  objectForKey:@"screen_name"]);
        onCompletion();
    }];
}

- (void)getUserDetails: (void (^)(NSString *username, NSString *userID))successBlock
{
    __weak typeof(self) weakSelf = self;
    
    [self initialize:^{
        successBlock(weakSelf.username, weakSelf.userID);
    }];
}


- (void) initWithURL: (NSString *)URL httpMethod:(NSString *)httpMethod parameters: (NSDictionary *)httpParameters withCompletionHandler: (void (^)(void)) onCompletion
{
    __weak typeof(self) weakSelf = self;
    [self initialize:^{
     
//        self.baseRequestURL = URL;
//        self.httpRequestMethod = httpMethod;
//        self.httpRequestParameters = httpParameters;
//        
//        NSMutableDictionary *oauthParametersWithoutSignature = [[NSMutableDictionary alloc] init];
//        [oauthParametersWithoutSignature setObject:self.oauthConsumerKey     forKey:@"oauth_consumer_key"];
//        [oauthParametersWithoutSignature setObject:self.oauthNonce           forKey:@"oauth_nonce"];
//        [oauthParametersWithoutSignature setObject:self.oauthSignatureMethod forKey:@"oauth_signature_method"];
//        [oauthParametersWithoutSignature setObject:self.oauthTimestamp       forKey:@"oauth_timestamp"];
//        [oauthParametersWithoutSignature setObject:self.oauthToken           forKey:@"oauth_token"];
//        [oauthParametersWithoutSignature setObject:self.oauthVersion         forKey:@"oauth_version"];
//        self.oauthParametersWITHOUTOauthSignature = oauthParametersWithoutSignature;
//        
//        NSMutableDictionary *oauthParametersWithSignature = [NSMutableDictionary dictionaryWithDictionary:oauthParametersWithoutSignature];
//        [oauthParametersWithSignature setObject:self.oauthSignature forKey:@"oauth_signature"];
//        self.oauthParametersWITHOauthSignature = oauthParametersWithSignature;
        
            weakSelf.baseRequestURL = URL;
            weakSelf.httpRequestMethod = httpMethod;
            weakSelf.httpRequestParameters = httpParameters;

            NSMutableDictionary *oauthParametersWithoutSignature = [[NSMutableDictionary alloc] init];
            [oauthParametersWithoutSignature setObject:weakSelf.oauthConsumerKey     forKey:@"oauth_consumer_key"];
            [oauthParametersWithoutSignature setObject:weakSelf.oauthNonce           forKey:@"oauth_nonce"];
            [oauthParametersWithoutSignature setObject:weakSelf.oauthSignatureMethod forKey:@"oauth_signature_method"];
            [oauthParametersWithoutSignature setObject:weakSelf.oauthTimestamp       forKey:@"oauth_timestamp"];
            [oauthParametersWithoutSignature setObject:weakSelf.oauthToken           forKey:@"oauth_token"];
            [oauthParametersWithoutSignature setObject:weakSelf.oauthVersion         forKey:@"oauth_version"];
            weakSelf.oauthParametersWITHOUTOauthSignature = oauthParametersWithoutSignature;

            NSMutableDictionary *oauthParametersWithSignature = [NSMutableDictionary dictionaryWithDictionary:oauthParametersWithoutSignature];
            [oauthParametersWithSignature setObject:weakSelf.oauthSignature forKey:@"oauth_signature"];
            weakSelf.oauthParametersWITHOauthSignature = oauthParametersWithSignature;
        
        onCompletion();
    }];
}

- (void)getAuthorizationHeader: (NSString *)URL httpMethod:(NSString *)httpMethod parameters: (NSDictionary *)httpParameters withCompletionHandler: (void (^)(NSString *authHeader))successBlock
{
    __weak typeof(self) weakSelf = self;
    [self initWithURL:URL httpMethod:httpMethod parameters:httpParameters withCompletionHandler:^{
        
        NSMutableString *authorizationHeader = [NSMutableString stringWithString:@"OAuth "];
        
        NSArray *sortedKeys = [[weakSelf.oauthParametersWITHOauthSignature allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableString *headerStringWithEncodedParameters = [[NSMutableString alloc] init];
        
        for (NSString *key in sortedKeys) {
            NSString *encodedKey = [weakSelf encodeString:key];
            
            NSString *encodedValue = [weakSelf encodeString:[weakSelf.oauthParametersWITHOauthSignature objectForKey:key]];
            NSString *queryParams = [NSString stringWithFormat:@"%@=\"%@\", ", encodedKey, encodedValue];
            [headerStringWithEncodedParameters appendString:queryParams];
        }
        NSUInteger trailingLength = [headerStringWithEncodedParameters length]-2; //remove trailing ',' and 'space'
        [authorizationHeader appendString:[headerStringWithEncodedParameters substringToIndex:trailingLength]];
        
        successBlock(authorizationHeader);
    }];
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
    //return @"kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg";
}

- (NSString *)oauthSignatureMethod
{
    return @"HMAC-SHA1";
}

- (NSString *)oauthTimestamp
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[[NSDate date] timeIntervalSince1970]];
    //return @"1318622958";
}

- (NSString *)oauthVersion
{
    return @"1.0";
}

//- (NSString *)oauthToken
//{
//    //return @"370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb";
//    
//}

//- (NSString *)oauthTokenSecret
//{
//    //return @"LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE";
//
//}

- (NSString *)oauthConsumerKey
{
    return CONSUMER_KEY;
    //return @"xvz1evFS4wEEPTGEFPHBog";
}

- (NSString *)oauthConsumerSecret
{
    return CONSUMER_KEY_SECRET;
    //return @"kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw";
}

- (NSString *)oauthSignature
{
    NSMutableDictionary *completeParameters = [NSMutableDictionary dictionaryWithDictionary:self.httpRequestParameters];
    [completeParameters addEntriesFromDictionary:self.oauthParametersWITHOUTOauthSignature];
    
    //Encode parameters
    NSMutableDictionary *encodedParameters = [NSMutableDictionary dictionaryWithCapacity:[completeParameters count]];
    for (NSString *key in completeParameters) {
        NSString *value = [completeParameters objectForKey:key];
        
        NSString *encodedKey = [self encodeString: key];
        NSString *encodedValue = [self encodeString:value];
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
    NSString *encodedBaseURL = [self encodeString:baseURL];
    NSString *encodedParameterString = [self encodeString:parameterString];

    NSMutableString *baseSignature = [NSMutableString stringWithString:[httpMethod uppercaseString]];
    [baseSignature appendString:@"&"];
    [baseSignature appendString:encodedBaseURL];
    [baseSignature appendString:@"&"];
    [baseSignature appendString:encodedParameterString];
    
    //Create signing key
    NSString *encodedConsumerSecret = [self encodeString:self.oauthConsumerSecret];
    NSString *encodedOauthTokenSecret = [self encodeString:self.oauthTokenSecret];
    
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


#pragma mark - Helper methods

//Twitter Percent Encoding based on RFC 3986
//https://dev.twitter.com/oauth/overview/percent-encoding-parameters

- (NSString *)encodeString: (NSString *)str
{
    NSString *allowedCharacterString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~";
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:allowedCharacterString];
    
    NSString *encodedStr = [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    return encodedStr;
}

@end
