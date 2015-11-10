//
//  NSString+TwitterEncode.m
//  Tweet-to
//
//  Created by shitij.c on 10/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "NSString+TwitterEncode.h"

@implementation NSString (TwitterEncode)

//Twitter Percent Encoding based on RFC 3986
//https://dev.twitter.com/oauth/overview/percent-encoding-parameters

- (NSString *)stringByTwitterEncodingString;
{
    NSString *allowedCharacterString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~";
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:allowedCharacterString];
    
    NSString *encodedStr = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    return encodedStr;
}

@end
