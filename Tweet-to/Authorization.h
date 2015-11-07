//
//  Authorization.h
//  Tweet-to
//
//  Created by shitij.c on 09/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Authorization : NSObject

#pragma Authorization: OAuth parameters

//- (NSString *)getAuthorizationHeader;
- (void)getUserDetails: (void (^)(NSString *username, NSString *userID))successBlock;

- (void)getAuthorizationHeader: (NSString *)URL httpMethod:(NSString *)httpMethod parameters: (NSDictionary *)httpParameters withCompletionHandler: (void (^)(NSString *authHeader))successBlock;

- (NSString *)encodeString: (NSString *)str;

@end
