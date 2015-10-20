//
//  HomeTimelineTableViewController.m
//  Tweet-to
//
//  Created by shitij.c on 12/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "HomeTimelineTableViewController.h"
#import "TwitterFeed.h"
#import "TweetJsonParams.h"
#import "TweetTableViewCell.h"


@interface HomeTimelineTableViewController ()
@property (strong, nonatomic) NSArray *tweets; // Array of Tweet Dictionaries

@end

@implementation HomeTimelineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = YES;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTweets)forControlEvents:UIControlEventValueChanged];
    
    TwitterFeed *twitterFeed = [[TwitterFeed alloc] init];
    
    [twitterFeed getUserHomeTimelineData:^(NSArray *tweets) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tweets = tweets;
            NSLog(@"tweets set");
        });
    }];
    
#warning IOS 8.0 feature -- Untested on 7.0
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}


- (void)refreshTweets
{
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void) setTweets:(NSArray *)tweets {
    _tweets = tweets;
    [self.tableView reloadData];
    NSLog(@"reload data");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Tweet count %ld", [self.tweets count]);
    return MAX(1, [self.tweets count]); /* Add atleast 1 placeholder */
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"start setup cell");
    
    NSUInteger nodeCount = [self.tweets count];

    if(nodeCount == 0 ) {
        UITableViewCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolderCell" forIndexPath:indexPath];
        return placeHolderCell;
    }
    
    TweetTableViewCell *tweetCell = (TweetTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"HomeTimelineCell" forIndexPath:indexPath];
    
    // Configure the cell...
    // reset cell image or use prepare for reuse
    
    tweetCell.profileImage.image = nil;
    [self configureCell:tweetCell forRowAtIndexPath:indexPath];
    
    return tweetCell;
 
}


- (void)configureCell:(TweetTableViewCell *)tweetCell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tweet = self.tweets[indexPath.row];

#warning Use array(or core data) -- do not fetch every time
    
    NSURL *tweetURL = [NSURL URLWithString :[tweet valueForKeyPath:IMAGE_URL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:tweetURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:tweetURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            if([request.URL isEqual:tweetURL]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    tweetCell.profileImage.image = image;
                });
            }
        }
    }];
    
    [downloadTask resume];

    
    
    tweetCell.nameLabel.text = [tweet valueForKeyPath:NAME];
    
    NSString *twitterHandle = @"@";
    twitterHandle = [twitterHandle stringByAppendingString:[tweet valueForKeyPath:USERNAME]];
    tweetCell.twitterHandleLabel.text = twitterHandle;
    
    tweetCell.tweetLabel.text = [tweet valueForKeyPath:TEXT];
    tweetCell.tweetLabel.numberOfLines = 0;
    
    
#warning Check for performance issues
    tweetCell.tweetLabel.layer.masksToBounds = YES;
    tweetCell.tweetLabel.layer.cornerRadius = 8.0;
        
    //tweetCell.profileImage.image = image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 - (CGFloat)tableView:(UITableView *)tableView
 heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 [self configureCell:self.protoCell forRowAtIndexPath:indexPath];
 
 NSLog(@"label before %f %f", self.protoCell.tweetLabel.bounds.size.height, self.protoCell.tweetLabel.bounds.size.width);
 
 
 // self.protoCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.protoCell.bounds));
 // NSLog(@"label %f %f", self.protoCell.bounds.size.height, self.protoCell.bounds.size.width);
 
 [self.protoCell setNeedsLayout];
 [self.protoCell layoutIfNeeded];
 
 //CGSize size = [self.protoCell.contentView systemLayoutSizeFittingSize:UI];
 
 NSLog(@"label after %f %f", self.protoCell.tweetLabel.bounds.size.height, self.protoCell.tweetLabel.bounds.size.width);
 
 NSLog(@" cell bounds %f %f", self.protoCell.bounds.size.height, self.protoCell.bounds.size.width);
 
 CGSize size = self.protoCell.contentView.bounds.size;
 NSLog(@" content view %f %f", size.height, size.width);
 
 return size.height+1;
 }
 */


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
