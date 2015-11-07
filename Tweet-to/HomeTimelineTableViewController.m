//
//  HomeTimelineTableViewController.m
//  Tweet-to
//
//  Created by shitij.c on 12/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "HomeTimelineTableViewController.h"
#import "TweetTableViewCell.h"

#import "TwitterFeed.h"
#import "TweetJsonParams.h"
#import "ImageDownload.h"

#import "CreateTweetViewController.h"
#import "UserTimelineTableViewController.h"


@interface HomeTimelineTableViewController ()
//@property (strong, nonatomic) TweetTableViewCell *protoCell;
@end

@implementation HomeTimelineTableViewController

- (void)viewDidLoad {
    
    //--------------------
    // Tweet bar button
    //--------------------
    UIImage *image = [[UIImage imageNamed:@"twitter-about.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, 30, 25);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTweetButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tweetBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = tweetBarButton;
    
    [super viewDidLoad];
    [self fetchTweets];
}


- (void)onTweetButtonTapped
{
    NSLog(@"Tweet button tapped");
}

- (void) fetchTweets
{
    TwitterFeed *twitterAPI = [[TwitterFeed alloc] init];
    [twitterAPI getUserHomeTimelineData:^(NSArray *tweets) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tweets = tweets;
            NSLog(@"tweets set");
        });
    }];
}

#pragma mark - Table view data source

// From super class


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller
    // Pass the selected object to the new view controller.
    
    if([[segue destinationViewController] isKindOfClass:[UserTimelineTableViewController class]] ) {
        UserTimelineTableViewController *userController = [segue destinationViewController];
        if([sender isKindOfClass:[TweetTableViewCell class]]) {
            
            TweetTableViewCell *tweetCell = (TweetTableViewCell *)sender;
            userController.screenName = tweetCell.nameLabel.text;
            userController.username = tweetCell.twitterHandleLabel.text;
        }
    }
}

#warning Use encapsulation better : move code to source view controller

- (IBAction)sendTweetAndReturnToHomeTimeline:(UIStoryboardSegue *)unwindSegue
{
    if([unwindSegue.sourceViewController isKindOfClass:[CreateTweetViewController class]]) {
        CreateTweetViewController *tweetController = unwindSegue.sourceViewController;
        [tweetController sendTweet];
    }
}

- (IBAction)backToHomeTimleine:(UIStoryboardSegue *)unwindSegue
{
    NSLog(@"returned to home timline from %@", unwindSegue.sourceViewController);
}

@end
