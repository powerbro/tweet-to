//
//  TweetTableViewCell.h
//  Tweet-to
//
//  Created by shitij.c on 15/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;

@end
