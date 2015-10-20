//
//  ViewController.m
//  Tweet-to
//
//  Created by shitij.c on 06/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "ViewController.h"
#import "STTwitterAPI.h"

@import Accounts;

@interface ViewController ()

@property (strong, nonatomic) STTwitterAPI *twitter;

@end


NSString *consumerKey = @"U8Cr0pQBxyW1ax1A8EAhfBxpO";
NSString *consumerSecret = @"KP6I1ZaeC1b7dR15lpkP9ETE55FXDqMT8FCIRzRN6tUekjvBs2";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

/*
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey: consumerKey
                                                 consumerSecret: consumerSecret];
    
    [self.twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.loginWebView loadRequest:request];
     
        } authenticateInsteadOfAuthorize:NO
                        forceLogin:@(YES)
                        screenName:nil
                     oauthCallback:@"tweetto://riva/"
                        errorBlock:^(NSError *error) {
                            NSLog(@"-- error: %@", error);
                        }
     ];
 
*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
