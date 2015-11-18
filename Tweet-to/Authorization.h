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

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userID;

- (NSString *)getAuthorizationHeader: (NSString *)URL httpMethod:(NSString *)httpMethod parameters: (NSDictionary *)httpParameters;

@end
