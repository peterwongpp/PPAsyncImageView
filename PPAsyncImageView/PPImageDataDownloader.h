//
//  PPImageDataDownloader.h
//  PPAsyncImageViewDemo
//
//  Created by Peter Wong on 13/1/14.
//  Copyright (c) 2014 PPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPImageDataDownloader : NSObject

// Will start the request automatically!
+ (void) loadWithURL:(NSURL *)url completionHandler:(void (^)(NSData *imageData))completionHandler;

// Will start the request automatically!
- (id) initWithURL:(NSURL *)url completionHandler:(void (^)(NSData *imageData))completionHandler;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) void (^completionHandler)(NSData *imageData);

@end
