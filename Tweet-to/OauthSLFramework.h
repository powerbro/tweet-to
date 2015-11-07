//
//  OauthSLFramework.h
//  Tweet-to
//
//  Created by shitij.c on 03/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OauthSLFramework : NSObject

- (void)getUserAccessTokensFromACAccount:(void (^)(NSDictionary *userAccessTokens))fetchAccessTokenDict;

@end
