//
//  GenericTweetTableViewController.h
//  Tweet-to
//
//  Created by shitij.c on 27/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TweetTableViewCell.h"


@interface GenericTweetTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

//Subclasses must implement
- (void)fetchTweets;
- (NSFetchedResultsController *)fetchedResultsController;

@end
