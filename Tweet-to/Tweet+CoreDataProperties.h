//
//  Tweet+CoreDataProperties.h
//  Tweet-to
//
//  Created by shitij.c on 08/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSString *tweet_id;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) User *created_by;

@end

NS_ASSUME_NONNULL_END
