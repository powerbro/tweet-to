//
//  ImageDownload.h
//  Tweet-to
//
//  Created by shitij.c on 26/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageDownload : NSObject
+ (void)downloadImageAsync:(NSURL *)imageURL setImage:(void(^)(NSData *)) imageFetcher;
@end
