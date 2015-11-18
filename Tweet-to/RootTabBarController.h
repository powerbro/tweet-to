//
//  RootTabBarController.h
//  Tweet-to
//
//  Created by shitij.c on 16/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTabBarController : UITabBarController <UITabBarControllerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
