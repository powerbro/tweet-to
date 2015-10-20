//
//  TweetTableViewCell.m
//  Tweet-to
//
//  Created by shitij.c on 15/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "TweetTableViewCell.h"

@implementation TweetTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
