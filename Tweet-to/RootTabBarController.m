//
//  RootTabBarController.m
//  Tweet-to
//
//  Created by shitij.c on 16/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "RootTabBarController.h"
#import "HomeTimelineTableViewController.h"
#import "FollowerTableViewController.h"
#import "MyTweetsTableViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    id vc = [[[self.viewControllers firstObject] childViewControllers] firstObject];
    if ([vc isKindOfClass:[HomeTimelineTableViewController class]]) {
        [vc setManagedObjectContext:self.managedObjectContext];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    id vc = [[viewController childViewControllers] firstObject];
    if([vc  respondsToSelector:@selector(setManagedObjectContext:)]) {
        [vc setManagedObjectContext:self.managedObjectContext];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
