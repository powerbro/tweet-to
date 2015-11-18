//
//  FollowerTableViewController.h
//  Tweet-to
//
//  Created by shitij.c on 06/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface FollowerTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
