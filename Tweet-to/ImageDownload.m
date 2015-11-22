//
//  ImageDownload.m
//  Tweet-to
//
//  Created by shitij.c on 26/10/15.
//  Copyright © 2015 Riva. All rights reserved.
//

#import "ImageDownload.h"

@implementation ImageDownload

+ (void)downloadImageAsync:(NSURL *)imageURL setImage:(void(^)(NSData *)) imageFetcher;
{
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:imageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            if([response.URL isEqual:request.URL]) {
                NSData *imageData = [NSData dataWithContentsOfURL:location];
                imageFetcher(imageData);
                //NSLog(@"image response: %@", response);
            }
        }
        else {
            NSLog(@" Error downloading image: %@", error);
        }
    }];
    
    [downloadTask resume];
}

@end
