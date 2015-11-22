//
//  UserTimelineTableViewController.m
//  Tweet-to
//
//  Created by shitij.c on 23/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "UserTimelineTableViewController.h"

#import "TwitterFeed.h"
#import "Tweet.h"
#import "User.h"

#import "ImageDownload.h"

@interface UserTimelineTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) TwitterFeed *twitterAPI;

@end


@implementation UserTimelineTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    
    self.navigationItem.title = self.screenName;
    self.navigationItem.prompt = [@"@" stringByAppendingString:self.username];
    [super viewDidLoad];

    if(!_twitterAPI)
        _twitterAPI = [[TwitterFeed alloc] init];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    //NSLog(@"Error in NFRC of user timeline : %@", error);
    [self fetchTweets];
    [self fetchUserDetailsForUsername:self.username];
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController)
        return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"created_by.username == %@", self.username];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tweet_id"
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;

}

- (void)fetchTweets
{
    [self.twitterAPI getLastPostedTweetsForUser:self.username tweetCount:10 withCompletionHandler:^(NSArray *tweets) {
        NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [backgroundMOC setParentContext:self.managedObjectContext];
        [backgroundMOC performBlock:^{
            [Tweet loadTweetsFromTwitterArray:tweets fromTimelineOfUser:self.username
                     intoManagedObjectContext:backgroundMOC];
        }];
    }];
}

- (void)fetchUserDetailsForUsername:(NSString *)username
{
    User *user = [User createUserWithUsername:username screenName:nil
                              profileImageURL:nil
                       inManagedObjectContext:self.managedObjectContext];
    
    self.profileImageView.layer.borderWidth = 2.0;
    self.profileImageView.layer.borderColor =  [[UIColor whiteColor] CGColor];

    self.bannerImageView.layer.borderWidth = 1.0;
    self.bannerImageView.layer.cornerRadius = 8.0;
    self.bannerImageView.layer.borderColor =  [[UIColor blackColor] CGColor];
    
    if (user.banner_image_url && user.image_url) {
        [self fetchBannerImageForUser:user];
        [self fetchProfileImageForUser:user];
    }
    else
    {
        [self.twitterAPI getUserData:self.username withCompletionHandler:^(NSDictionary *userData) {
            NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc]
                                                     initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            
            [backgroundMOC setParentContext:self.managedObjectContext];
            [backgroundMOC performBlock:^{
                User *user = [User loadUserDataFromUserDictionary:userData inManagedObjectContext:backgroundMOC];
                
                // Download banner and profile image
                [self fetchBannerImageForUser:user];
                [self fetchProfileImageForUser:user];
            }];
        }];
    }
}

- (void)fetchProfileImageForUser:(User *)user
{
    NSString *profileString = [user.image_url stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profileURL = [NSURL URLWithString:profileString];
    
    [ImageDownload downloadImageAsync:profileURL setImage:^(NSData *imageData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileImageView.image = [UIImage imageWithData:imageData];
        });
    }];
}


- (void)fetchBannerImageForUser:(User *)user
{
    NSURL *bannerURL = [NSURL URLWithString:user.banner_image_url];
    
    [ImageDownload downloadImageAsync:bannerURL setImage:^(NSData *imageData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            if(image) {
                self.bannerImageView.image = image;
                self.bannerImageView.alpha = 1.0;
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// from super class

@end
