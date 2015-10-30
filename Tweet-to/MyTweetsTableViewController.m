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

@end

@implementation MyTweetsTableViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    
    TwitterFeed *twitterAPI = [[TwitterFeed alloc] init];
    [twitterAPI getUsernameFromACAccount:^(NSString *username) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.username = [@"@" stringByAppendingString:username];
            self.screenName = [@"What's up " stringByAppendingString:self.username];
            [super viewDidLoad];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
