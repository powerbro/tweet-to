//
//  User+CoreDataProperties.m
//  Tweet-to
//
//  Created by shitij.c on 08/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

@dynamic created_at;
@dynamic user_id;
@dynamic name;
@dynamic username;
@dynamic image_url;
@dynamic banner_image_url;
@dynamic profile_image;
@dynamic profile_image_thumbnail;
@dynamic creates;
@dynamic followed_by;
@dynamic following;

@end
