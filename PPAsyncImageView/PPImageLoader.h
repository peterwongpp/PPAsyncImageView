//
//  PPImageLoader.h
//  PPAsyncImageViewDemo
//
//  Created by Peter Wong on 13/1/14.
//  Copyright (c) 2014 PPP. All rights reserved.
//

#import <Foundation/Foundation.h>

// Given an imageName, get the image from cache if exists, or else try to download and cache it
@interface PPImageLoader : NSObject

+ (PPImageLoader *) sharedInstance;

- (void) loadImageNamed:(NSString *)imageName completion:(void (^)(NSString *imageName, UIImage *image))completion;

- (void) clearCache;

@end
