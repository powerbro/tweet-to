//
//  FollowerTableViewController.m
//  Tweet-to
//
//  Created by shitij.c on 06/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "FollowerTableViewController.h"
#import "TwitterFeed.h"
#import "FollowingJsonParams.h"

@interface FollowerTableViewController()

@property (strong , nonatomic) NSString *username;
@property (strong, nonatomic) NSArray *followers; // contains user dictionary of every follower
@end

@implementation FollowerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchFollowers];
}


#pragma mark - Table view data source

- (void) fetchFollowers
{
    TwitterFeed *twitterAPI = [[TwitterFeed alloc] init];
    [twitterAPI getUsernameOnInitialization:^(NSString *username) {
         [twitterAPI getFollowersList:username withCompletionHandler:^(NSArray *followerList) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.username = username;
                self.followers = followerList;
            });
         }];
    }];
}

-(void)setFollowers:(NSArray *)followers
{
    _followers = followers;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nodeCount = [self.followers count];
    return MAX(1, nodeCount);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nodeCount = [self.followers count];
    
    if (nodeCount == 0) {
        UITableViewCell *followerCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolderCell" forIndexPath:indexPath];
        return followerCell;
    }
    
    UITableViewCell *followerCell = [tableView dequeueReusableCellWithIdentifier:@"followers" forIndexPath:indexPath];
    [self configureCell:followerCell cellForRowAtIndexPath:indexPath];
    
    return followerCell;
}

- (void)configureCell:(UITableViewCell *)followerCell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *follower = self.followers[indexPath.row];
    followerCell.textLabel.text = [follower valueForKeyPath:NAME];
    followerCell.detailTextLabel.text = [@"@" stringByAppendingString:[follower valueForKeyPath:USERNAME]];
    followerCell.imageView.image = [UIImage imageNamed:@"tweet.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


@end
