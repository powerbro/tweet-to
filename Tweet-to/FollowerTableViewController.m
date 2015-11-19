//
//  FollowerTableViewController.m
//  Tweet-to
//
//  Created by shitij.c on 06/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "FollowerTableViewController.h"
#import "FollowingJsonParams.h"
#import "ImageDownload.h"

#import "TwitterFeed.h"
#import "User.h"

@interface FollowerTableViewController()

@property (strong, nonatomic) NSString *myUsername;
@property (strong, nonatomic) TwitterFeed *twitterAPI;
@end

@implementation FollowerTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    if(!_twitterAPI)
        _twitterAPI = [[TwitterFeed alloc] init];
    self.myUsername = _twitterAPI.username;
    
    [super viewDidLoad];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    //NSLog(@"Errors in NFRC for followers: %@", error);
    [self fetchFollowers];
}

- (void) fetchFollowers
{
    [self.twitterAPI getFollowersList:self.myUsername withCompletionHandler:^(NSArray *followerList) {
        
        NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc]
                                                 initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [backgroundMOC setParentContext:self.managedObjectContext];
        [backgroundMOC performBlock:^{
            for (NSDictionary *followerDict in followerList) {
                [User createFollowerForUser:self.myUsername
                               withUsername:[followerDict valueForKeyPath:USERNAME]
                                   withName:[followerDict valueForKey:NAME]
                               withImageURL:[followerDict valueForKey:IMAGE_URL]
                     inManagedObjectContext:backgroundMOC];
            }
        }];
    }];
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController)
        return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY following.username == %@", self.myUsername];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

#pragma mark - Table view data source


- (NSUInteger)countNodesInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger nodeCount = [self countNodesInSection:section];
    return nodeCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUInteger nodeCount = [self countNodesInSection:indexPath.section];
    User *follower = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (!follower) {
        UITableViewCell *followerCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolderCell" forIndexPath:indexPath];
        return followerCell;
    }
    
    UITableViewCell *followerCell = [tableView dequeueReusableCellWithIdentifier:@"followers" forIndexPath:indexPath];
    [self configureCell:followerCell atIndexPath:indexPath];
    
    return followerCell;
}

- (void)configureCell:(UITableViewCell *)followerCell atIndexPath:(NSIndexPath *)indexPath
{
    User *follower = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *profileString = [follower.image_url stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profileURL = [NSURL URLWithString:profileString];
    
    if (follower.profile_image) {
        followerCell.imageView.image = [UIImage imageWithData:follower.profile_image];
        followerCell.imageView.alpha = 1.0;
    }
    else {
        [ImageDownload downloadImageAsync:profileURL setImage:^(NSData *imageData) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableViewCell *followerCell = [self.tableView cellForRowAtIndexPath:indexPath];
                if(followerCell) {
                    followerCell.imageView.image = [UIImage imageWithData:imageData];
                    followerCell.imageView.alpha = 1.0;
                }
            });
            
            NSManagedObjectID *followerObjectID = follower.objectID;
            NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc]
                                                     initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            
            [backgroundMOC setParentContext:self.managedObjectContext];
            [backgroundMOC performBlock:^{
                User *updatedFollower = (User *)[backgroundMOC objectWithID:followerObjectID];
                [updatedFollower loadProfileImageWithData:imageData inManagedObjectContext:backgroundMOC];
            }];
        }];
    }
         
    followerCell.textLabel.text = follower.name;
    followerCell.detailTextLabel.text = [@"@" stringByAppendingString:follower.username];
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
