//
//  Tweet_toTests.m
//  Tweet-toTests
//
//  Created by shitij.c on 06/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Authorization.h"

@interface Tweet_toTests : XCTestCase

@end

@implementation Tweet_toTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    
//    NSString *url = @"https://api.twitter.com/1/statuses/update.json";
//    NSString *httpMethod = @"POST";
//    NSDictionary *params = @{@"status" : @"Hello Ladies + Gentlemen, a signed OAuth request!", @"include_entities": @"true"};
//    
//    Authorization *authorize = [[Authorization alloc] initWithURL:url httpMethod:httpMethod parameters:params];
//    NSString *oauthSign = [authorize oauthSignature];
//    XCTAssertEqualObjects(oauthSign, @"tnnArxj06cWHq44gCs1OSKk/jLY=");
//    
//    NSString *oauthHeader = [authorize getAuthorizationHeader];
//    NSLog(@"%@", oauthHeader);
//
//}

//- (void)testAnother {
//    
//    
//    NSString *url = @"https://api.twitter.com/1/statuses/update.json";
//    NSString *httpMethod = @"POST";
//    NSDictionary *params = @{@"status" : @"Hello Ladies + Gentlemen, a signed OAuth request!", @"include_entities": @"true"};
//    
//    Authorization *authorize = [[Authorization alloc] initWithURL:url httpMethod:httpMethod parameters:params];
//    NSString *oauthRandom = [authorize oauthNonce];
//    NSString *oauthTime = [authorize oauthTimestamp];
//    
//    NSLog(@"%@  %@", oauthRandom, oauthTime);
//}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


@end
