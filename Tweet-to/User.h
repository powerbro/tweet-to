//
//  User.h
//  Tweet-to
//
//  Created by shitij.c on 08/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (User *)createUserWithUsername:(NSString *)tweeterUsername screenName:(nullable NSString *)tweeterName profileImageURL:(nullable NSString *)tweeterImageURL inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (User *)loadUserDataFromUserDictionary:(NSDictionary *)userDictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (User *)createFollowerForUser:(NSString *)myUsername withUsername:(NSString *)followerUsername withName:(NSString *)followerName withImageURL:(NSString *)profileImageURL inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void)loadProfileImageWithData:(NSData *)imageData inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void)loadThumbnailProfileImageWithData:(NSData *)imageData inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;


@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
