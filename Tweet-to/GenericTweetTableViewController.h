//
//  GenericTweetTableViewController.h
//  Tweet-to
//
//  Created by shitij.c on 27/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericTweetTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *tweets;

//Subclasses must implement and set self.tweets
- (void)fetchTweets;

@end
