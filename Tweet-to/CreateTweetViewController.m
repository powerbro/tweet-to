//
//  CreateTweetViewController.m
//  Tweet-to
//
//  Created by shitij.c on 20/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "CreateTweetViewController.h"
#import "TwitterFeed.h"

@interface CreateTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterLimit;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelTweet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendTweetButton;

@end

#define MAX_CHARACTER_LIMIT 140

@implementation CreateTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tweetTextView.delegate = self;
    self.tweetTextView.layer.cornerRadius = 8.0;
    self.tweetTextView.textContainer.lineFragmentPadding = 0;
    self.tweetTextView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    //self.sendTweetButton.action = @selector(sendTweet);
}


- (void) sendTweet
{
    NSString *tweet = self.tweetTextView.text;
    
    TwitterFeed *twitterAPI = [[TwitterFeed alloc] init];
    [twitterAPI postTweet:tweet];
    
    NSLog(@"Tweet log: %@", tweet);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.characterLimit.text = [(@ MAX_CHARACTER_LIMIT) stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = nil;
    textView.textColor = [UIColor blackColor];
    //NSLog(@"will begin editing text");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"began editing text");
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.characterLimit.text = [@(MAX_CHARACTER_LIMIT - [textView.text length]) stringValue];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(!range.length) { //if delete is pressed range.length = 1 else 0
        if([textView.text length] >= MAX_CHARACTER_LIMIT) {
            return NO;
        }
    }
    return YES;
}



#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
