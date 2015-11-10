//
//  User+CoreDataProperties.h
//  Tweet-to
//
//  Created by shitij.c on 08/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *image_url;
@property (nullable, nonatomic, retain) NSString *banner_image_url;
@property (nullable, nonatomic, retain) NSData *profile_image;
@property (nullable, nonatomic, retain) NSData *profile_image_thumbnail;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *creates;
@property (nullable, nonatomic, retain) NSSet<User *> *followed_by;
@property (nullable, nonatomic, retain) NSSet<User *> *following;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCreatesObject:(NSManagedObject *)value;
- (void)removeCreatesObject:(NSManagedObject *)value;
- (void)addCreates:(NSSet<NSManagedObject *> *)values;
- (void)removeCreates:(NSSet<NSManagedObject *> *)values;

- (void)addFollowed_byObject:(User *)value;
- (void)removeFollowed_byObject:(User *)value;
- (void)addFollowed_by:(NSSet<User *> *)values;
- (void)removeFollowed_by:(NSSet<User *> *)values;

- (void)addFollowingObject:(User *)value;
- (void)removeFollowingObject:(User *)value;
- (void)addFollowing:(NSSet<User *> *)values;
- (void)removeFollowing:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
