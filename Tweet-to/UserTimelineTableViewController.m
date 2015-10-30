//
//  UserTimelineTableViewController.m
//  Tweet-to
//
//  Created by shitij.c on 23/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "UserTimelineTableViewController.h"

#import "TwitterFeed.h"
#import "UserJsonParams.h"

#import "ImageDownload.h"

@interface UserTimelineTableViewController ()
@property (strong, nonatomic) NSDictionary *userDetails;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation UserTimelineTableViewController

- (void)viewDidLoad {
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.title = self.screenName;
    self.navigationItem.prompt = self.username;

    TwitterFeed *twitterAPI = [[TwitterFeed alloc] init];
    [twitterAPI getUserData:self.username withCompletionHandler:^(NSDictionary *userData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userDetails = userData;
        });
    }];
    
    [super viewDidLoad];
}


- (void)fetchTweets
{
    TwitterFeed *twitterAPI = [[TwitterFeed alloc] init];

    [twitterAPI getUserTimelineData:self.username tweetCount:10 withCompletionHandler:^(NSArray *tweets) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tweets = tweets;
        });
    }];
}

- (void)setUserDetails:(NSDictionary *)userDetails
{
    _userDetails = userDetails;
    
    //----------------------
    // Download banner and profile image
    //----------------------
    NSURL *bannerURL = [NSURL URLWithString:[_userDetails valueForKeyPath:BANNER_IMAGE_URL]];
    //NSLog(@"banner image : %@", [_userDetails valueForKeyPath:BANNER_IMAGE_URL]);
    
    NSString *profileString = [_userDetails valueForKeyPath:IMAGE_URL];
    profileString = [profileString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profileURL = [NSURL URLWithString:profileString];
    
    ImageDownload *imageDownload = [[ImageDownload alloc] init];
    
    [imageDownload downloadImageAsync:bannerURL setImage:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(image) {
                self.bannerImageView.image = image;
                self.bannerImageView.alpha = 1.0;
            }
        });
    }];
    
    [imageDownload downloadImageAsync:profileURL setImage:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileImageView.image = image;
        });
    }];
    
    self.profileImageView.layer.borderWidth = 2.0;
    self.profileImageView.layer.borderColor =  [[UIColor whiteColor] CGColor];
    
    self.bannerImageView.layer.borderWidth = 1.0;
    self.bannerImageView.layer.cornerRadius = 8.0;
    self.bannerImageView.layer.borderColor =  [[UIColor blackColor] CGColor];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// from super class

#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
