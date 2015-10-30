//
//  UserTimelineTableViewController.h
//  Tweet-to
//
//  Created by shitij.c on 23/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTweetTableViewController.h"

@interface UserTimelineTableViewController : GenericTweetTableViewController
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *screenName;
@end
