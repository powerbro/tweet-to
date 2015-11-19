//
//  User.m
//  Tweet-to
//
//  Created by shitij.c on 08/11/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "User.h"
#import "UserJsonParams.h"

@implementation User

// Insert code here to add functionality to your managed object subclass

+ (User *)createUserWithUsername:(NSString *)tweeterUsername screenName:(nullable NSString *)tweeterName profileImageURL:(nullable NSString *)tweeterImageURL inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    User *user = [User userFromDBwithUsername:tweeterUsername inManagedObjectContext:managedObjectContext];
    
    if (user) {
        if (!user.name) user.name = tweeterName;
        if (!user.image_url) user.image_url = tweeterImageURL;
        return user;
    }
    
    user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
    user.username = tweeterUsername;
    user.name = tweeterName;
    user.image_url = tweeterImageURL;
    
    return user;
}


+ (User *)userFromDBwithUsername:(NSString *)username inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", username];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error while fetching user: %@",error);
        return nil;
    }
    
    return [fetchedObjects firstObject];
}

+ (User *)createFollowerForUser:(NSString *)myUsername withUsername:(NSString *)followerUsername withName:(NSString *)followerName
                   withImageURL:(NSString *)profileImageURL inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    User *myself = [User createUserWithUsername:myUsername
                                     screenName:nil
                                profileImageURL:nil
                         inManagedObjectContext:managedObjectContext];
    
    User *follower = [User createUserWithUsername:followerUsername
                                       screenName:followerUsername
                                  profileImageURL:profileImageURL
                           inManagedObjectContext:managedObjectContext];
    
    if ([myself.followed_by containsObject:follower] == NO) {
        [myself addFollowed_byObject:follower];
    }
    
    NSError *error;
    [managedObjectContext save:&error];
    return follower;
}


+ (User *)loadUserDataFromUserDictionary:(NSDictionary *)userDictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSString *username = [userDictionary valueForKeyPath:USERNAME];
    User *user = [User createUserWithUsername:username
                                   screenName:nil
                              profileImageURL:nil
                       inManagedObjectContext:managedObjectContext];
    
    NSString *userID = [userDictionary valueForKeyPath:ID];
    NSString *screenName = [userDictionary valueForKeyPath:NAME];
    NSString *createdAt = [userDictionary valueForKeyPath:CREATED_AT];
    NSString *profileImageURL = [userDictionary valueForKeyPath:IMAGE_URL];
    NSString *bannerImageURL = [userDictionary valueForKeyPath:BANNER_IMAGE_URL];
        
    user.created_at = createdAt;
    user.user_id = userID;
    user.name = screenName;
    user.image_url = profileImageURL;
    user.banner_image_url = bannerImageURL;

    NSError *error;
    [managedObjectContext save:&error];
    
    return user;
}

- (void)loadProfileImageWithData:(NSData *)imageData inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if(self) {
        self.profile_image = imageData;
        NSError *error;
        [managedObjectContext save:&error];
        //NSLog(@"%@", [error localizedDescription]);
    }
}

- (void)loadThumbnailProfileImageWithData:(NSData *)imageData inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if(self) {
        self.profile_image_thumbnail = imageData;
        NSError *error;
        [managedObjectContext save:&error];
    }
}


@end
