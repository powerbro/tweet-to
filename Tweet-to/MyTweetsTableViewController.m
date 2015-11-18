//
//  MyTweetsTableViewController.m
//  Tweet-to
//
//  Created by shitij.c on 27/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "MyTweetsTableViewController.h"
#import "TwitterFeed.h"

@interface MyTweetsTableViewController ()
@property (strong, nonatomic) TwitterFeed *twitterAPI;
@end

@implementation MyTweetsTableViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    
    if (!_twitterAPI) {
        _twitterAPI = [[TwitterFeed alloc] init];
    }
    
    self.username = _twitterAPI.username;
    self.screenName = [@"What's up " stringByAppendingString:self.username];
    
    [super viewDidLoad];
    [super fetchTweets];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
