//
//  TweetJsonParams.h
//  Tweet-to
//
//  Created by shitij.c on 13/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetJsonParams : NSObject

#define CREATED_AT          @"created_at"
#define ID                  @"id_str"
#define TEXT                @"text"
#define NAME                @"user.name"
#define USERNAME            @"user.screen_name"
#define IMAGE_URL           @"user.profile_image_url_https"
#define BANNER_IMAGE_URL    @"user.profile_banner_url"
@end
