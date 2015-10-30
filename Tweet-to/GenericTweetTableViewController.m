//
//  GenericTweetTableViewController.m
//  Tweet-to
//
//  Created by shitij.c on 27/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "GenericTweetTableViewController.h"
#import "TweetTableViewCell.h"

#import "TweetJsonParams.h"
#import "ImageDownload.h"


@interface GenericTweetTableViewController ()

@end

@implementation GenericTweetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTweets)forControlEvents:UIControlEventValueChanged];
    
    [self fetchTweets];
    
#warning IOS 8.0 feature -- Untested on 7.0
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)fetchTweets
{
    self.tweets = nil;
}

- (void)refreshTweets
{
    [self.refreshControl endRefreshing];
    [self fetchTweets];
}

- (void) setTweets:(NSArray *)tweets
{
    _tweets = tweets;
    [self.tableView reloadData];
    NSLog(@"reload data");
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, [self.tweets count]); /* Add atleast 1 placeholder */
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger nodeCount = [self.tweets count];
    
    if(nodeCount == 0 ) {
        UITableViewCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolderCell" forIndexPath:indexPath];
        return placeHolderCell;
    }
    
    TweetTableViewCell *tweetCell = (TweetTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"HomeTimelineCell" forIndexPath:indexPath];
    
    //-----------------
    // Configure the cell...
    // Reset cell image or use prepare for reuse
    //----------------------
    tweetCell.profileImage.image = nil;
    [self configureCell:tweetCell forRowAtIndexPath:indexPath];
    return tweetCell;
    
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 400.0f;
//}


// - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
// {
//     if ([self.tweets count]) {
//         
//         TweetTableViewCell *protoCell = (TweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeTimelineCell"];
//         [self configureCell:protoCell forRowAtIndexPath:indexPath];
//         
//         //NSLog(@"Label height: %f width  : %f", protoCell.tweetLabel.frame.size.height, protoCell.tweetLabel.frame.size.width);
//         [protoCell setNeedsUpdateConstraints];
//         [protoCell updateConstraintsIfNeeded];
//         
//         protoCell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(protoCell.bounds));
//         protoCell.tweetLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);
//
//         protoCell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//         
//         CGSize size = [protoCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//         CGSize size = protoCell.contentView.bounds.size;
//         NSLog(@"content view height: %f width  : %f", size.height, size.width);
//         return  size.height + 1;
//     }
//     
//         
//         CGFloat maxHeight = 50, maxWidth = 50;
//         [protoCell setBounds:CGRectMake(0, 0, maxWidth, maxHeight)];
//         [self configureCell: protoCell forRowAtIndexPath:indexPath];
//         
// 
//         protoCell.tweetLabel.numberOfLines = 0;
//         protoCell.tweetLabel.text = @"Alkasjdlkjsdkljkalsdjlkjsalkdjklasjdklsajkldjsakldjklasjdklajskldjaslkdjklsajdlaksjdkljsdlkjslakdjklsajdkljsajkldjsakldjklasjdklajskldjaslkdjklsajdlaksjdkljsdlkjslakdjklsajjkldjsakldjklasjdklajskldjaslkdjklsajdlaksjdkljsdlkjslakdjklsajdkljsajkldjsakldjklasjdklajskldjaslkdjklsajdlaksjdkljsdlkjslakdjklsajdkljsajkldjsakldjklasjdklajskldjaslkdjklsajdlaksjdkljsdlkjslakdjklsajdkljsadkljjkldjsakldjklasjdklajskldjaslkdjklsajdlaksjdkljsdljkldjsakldjklasjdklajskldjaslkdjklsajdlaksjdkljsdlkjslakdjklsajdkljsakjslakdjklsajdkljsasa";
//         [protoCell.tweetLabel layoutIfNeeded];
//         NSUInteger height =  protoCell.tweetLabel.frame.size.height;
//     
//         NSLog(@"Label height  : %lu", height);
//         
//         
//         protoCell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//         
//         [protoCell setNeedsLayout];
//         [protoCell layoutIfNeeded];
//         
//         [protoCell.contentView sizeToFit];
//         CGSize size = protoCell.frame.size;
//         CGSize  = protoCell.
//         NSLog(@" height = %f   width  = %f", protoCell.tweetLabel.frame.size.height, protoCell.tweetLabel.frame.size.width);
//         return size.height + 1;
// 
//     return 120;
// }
//

- (void)configureCell:(TweetTableViewCell *)tweetCell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tweet = self.tweets[indexPath.row];
    
    #warning Use array(or core data) -- do not fetch every time
    
    //--------------------
    // Send NSURL request to fetch profile icon
    //---------------------
    NSURL *tweetURL = [NSURL URLWithString :[tweet valueForKeyPath:IMAGE_URL]];
    
    ImageDownload *imageDownload = [[ImageDownload alloc] init];
    [imageDownload downloadImageAsync:tweetURL setImage:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            tweetCell.profileImage.image = image;
        });
    }];
    
    tweetCell.nameLabel.text = [tweet valueForKeyPath:NAME];
    
    NSString *twitterHandle = @"@";
    twitterHandle = [twitterHandle stringByAppendingString:[tweet valueForKeyPath:USERNAME]];
    tweetCell.twitterHandleLabel.text = twitterHandle;
    
    tweetCell.tweetLabel.text = [tweet valueForKeyPath:TEXT];
    tweetCell.tweetLabel.numberOfLines = 0;
    
    tweetCell.tweetLabel.layer.masksToBounds = YES;
    tweetCell.tweetLabel.layer.cornerRadius = 8.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

@end
