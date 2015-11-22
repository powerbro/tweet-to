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
#import "Tweet.h"

#import "CreateTweetViewController.h"
#import "UserTimelineTableViewController.h"

@interface HomeTimelineTableViewController ()

@property (strong, nonatomic) NSString *myUsername;
@property (strong, nonatomic) TwitterFeed *twitterAPI;
@end


@implementation HomeTimelineTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    
    [self setupTweetBarButton];
    [super viewDidLoad];
    
    if(!_twitterAPI)
        _twitterAPI = [[TwitterFeed alloc] init];
    self.myUsername = _twitterAPI.username;
    NSLog(@"user %@", self.myUsername);
    
#warning Show alert and quit
    if (!self.myUsername) {
        NSLog(@"Connect to internet. Quitting ...");
    }
    else {
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        NSLog(@"%@", error);
        [self fetchTweets];
    }
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController)
        return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from_timeline.username == %@", self.myUsername];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    //NSSortDescriptor *sortByUser = [[NSSortDescriptor alloc] initWithKey:@"from_timeline.username" ascending:YES];
    NSSortDescriptor *sortByTime = [[NSSortDescriptor alloc] initWithKey:@"tweet_id" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortByTime, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}


- (void)setupTweetBarButton
{
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

}

- (void)onTweetButtonTapped
{
    NSLog(@"Tweet button tapped");
}

- (void) fetchTweets
{
    [self.twitterAPI getHomeTimelineData:^(NSArray *tweets) {
        NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [backgroundMOC setParentContext:self.managedObjectContext];
        [backgroundMOC performBlock:^{
            [Tweet loadTweetsFromTwitterArray:tweets fromTimelineOfUser:self.myUsername
                     intoManagedObjectContext:backgroundMOC];
            NSLog(@"tweets set");
        }];
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
            userController.username = [tweetCell.twitterHandleLabel.text substringFromIndex:1];
            userController.managedObjectContext = self.managedObjectContext;
            userController.imageCache = self.imageCache;
        }
    }
}


- (IBAction)backToHomeTimleine:(UIStoryboardSegue *)unwindSegue
{
    NSLog(@"Returned to home timline from %@", unwindSegue.sourceViewController);
}

@end
