//
//  GenericTweetTableViewController.m
//  Tweet-to
//
//  Created by shitij.c on 27/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "GenericTweetTableViewController.h"
#import "Tweet.h"
#import "User.h"

#import "ImageDownload.h"

@interface GenericTweetTableViewController ()
@end

@implementation GenericTweetTableViewController

@dynamic fetchedResultsController;

#pragma mark - Generic method implementation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTweets)forControlEvents:UIControlEventValueChanged];
}

- (void)fetchTweets { }

- (void)refreshTweets
{
    [self.refreshControl endRefreshing];
    [self fetchTweets];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        //NSLog(@"rows %lu", [sectionInfo numberOfObjects]);
        //NSLog(@"sections %lu", [[self.fetchedResultsController sections] count]);
        return [sectionInfo numberOfObjects];
    }
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(!tweet) {
        UITableViewCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolderCell" forIndexPath:indexPath];
        return placeHolderCell;
    }
    
    if (![tweet isKindOfClass:[Tweet class]])
        NSLog(@"Something went wrong while fetching results from core data");
        
    TweetTableViewCell *tweetCell = (TweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeTimelineCell" forIndexPath:indexPath];
    [self configureCell:tweetCell atIndexPath:indexPath];
    
    return tweetCell;
}


- (CGRect)rectForText:(NSString *)text usingFont:(UIFont *)font boundedBySize:(CGSize)maxSize
{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text
                                    attributes:@{ NSFontAttributeName:font}];
    
    return [attrString boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     Tweet *tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
     if(tweet) {
         NSString *tweetText = tweet.text;

         CGFloat standardMargin = 5.0f;
         CGFloat imageWidth = 48.0f;
         CGFloat screenWidth = tableView.contentSize.width - 50.0f;
         
         CGFloat labelWidth = screenWidth - imageWidth - standardMargin*2.0;
         CGFloat labelHeight = 2500.0f; // max height for label;
         CGFloat nameLabelHeight = 25.0f;
         CGFloat extraPadding = 10.0f + 5.0f;
         CGFloat remainingHeight = nameLabelHeight + extraPadding + standardMargin*2.0;
      
         CGRect rec = [self rectForText:tweetText usingFont:[UIFont systemFontOfSize:14.0]
                          boundedBySize:CGSizeMake(labelWidth, labelHeight)];
         return rec.size.height + remainingHeight;
     }
    
     return 120;
 }



- (void)configureCell:(TweetTableViewCell *)tweetCell atIndexPath:(NSIndexPath *)indexPath {
    
    Tweet *tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    User *user = tweet.created_by;
    
    NSString *profileString = [user.image_url stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profileURL = [NSURL URLWithString:profileString];
    
    if (!user.profile_image) {
        NSManagedObjectID *userObjectID = user.objectID;
        
        [ImageDownload downloadImageAsync:profileURL setImage:^(NSData *imageData) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *path = [self.tableView indexPathForCell:tweetCell];
                if([self.tableView.indexPathsForVisibleRows containsObject:path]) {
                    tweetCell.profileImage.image = [UIImage imageWithData:imageData];
                }
            });
            
            NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc]
                                                     initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [backgroundMOC setParentContext:self.managedObjectContext];
            [backgroundMOC performBlock:^{
                User *updatedUser = (User *)[backgroundMOC objectWithID:userObjectID];
                //Tweet *updatedTweet = (Tweet *)[backgroundMOC objectWithID:tweetObjectID];
                
                [updatedUser loadProfileImageWithData:imageData inManagedObjectContext:backgroundMOC];
            }];
        }];
    }
    else
    {
        tweetCell.profileImage.image = [UIImage imageWithData: user.profile_image];
    }
    
    tweetCell.nameLabel.text = user.name;
    
    NSString *twitterHandle = [@"@" stringByAppendingString:user.username];
    tweetCell.twitterHandleLabel.text = twitterHandle;
    
    tweetCell.tweetLabel.text = tweet.text;
    tweetCell.tweetLabel.numberOfLines = 0;
    
    tweetCell.tweetLabel.layer.masksToBounds = YES;
    tweetCell.tweetLabel.layer.cornerRadius = 8.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - NSFetchResultController Delegate

/*
 Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
 subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
 with information from a managed object at the given index path in the fetched results controller.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark - Navigation



@end
