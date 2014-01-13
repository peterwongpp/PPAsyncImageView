//
//  PPImageLoader.m
//  PPAsyncImageViewDemo
//
//  Created by Peter Wong on 13/1/14.
//  Copyright (c) 2014 PPP. All rights reserved.
//

#import "PPImageLoader.h"
#import "PPImageDataDownloader.h"
#import "NSString+MD5.h"

@interface PPImageLoader ()

@property (nonatomic, strong) NSCache *cache;

- (NSString *) hashOfImageName:(NSString *)imageName;

- (void) writeImageToCacheDirectory:(UIImage *)image withImageName:(NSString *)imageName;
- (UIImage *) readImageFromCacheDirectoryWithImageName:(NSString *)imageName;

- (void) doneWithImageNamed:(NSString *)imageName image:(UIImage *)image completion:(void (^)(NSString *imageName, UIImage *image))completion;

@end

@implementation PPImageLoader

+ (PPImageLoader *)sharedInstance
{
    static PPImageLoader *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PPImageLoader alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

- (void)loadImageNamed:(NSString *)imageName completion:(void (^)(NSString *, UIImage *))completion
{
    UIImage *image;
    
    // 1. Static file system level.
    
    image = [UIImage imageNamed:imageName];
    if (image) {
        [self doneWithImageNamed:imageName image:image completion:completion];
        return;
    }
    
    // 2. Memory cache level.
    
    image = (UIImage *)[self.cache objectForKey:imageName];
    if (image) {
        [self doneWithImageNamed:imageName image:image completion:completion];
        return;
    }
    
    // 3. Cached file system level
    
    image = [self readImageFromCacheDirectoryWithImageName:imageName];
    if (image) {
        [self doneWithImageNamed:imageName image:image completion:completion];
        return;
    }
    
    // 4. Web level
    
    [PPImageDataDownloader loadWithURL:[NSURL URLWithString:imageName]  completionHandler:^(NSData *imageData) {
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            [self writeImageToCacheDirectory:image withImageName:imageName];
            [self.cache setObject:image forKey:imageName];
            [self doneWithImageNamed:imageName image:image completion:completion];
        } else {
            [self doneWithImageNamed:imageName image:nil completion:completion];
        }
    }];
}

- (void)doneWithImageNamed:(NSString *)imageName image:(UIImage *)image completion:(void (^)(NSString *, UIImage *))completion
{
    completion(imageName, image);
}

- (NSString *)hashOfImageName:(NSString *)imageName
{
    return [imageName md5];
}

- (void)writeImageToCacheDirectory:(UIImage *)image withImageName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSString *cacheDirectory = [cachePath stringByAppendingPathComponent:@"PPAsyncImageViewCaches"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"[PPAsyncImageLoader] Failed to create the cache directory, error: %@", error);
            return;
        }
    }
    
    CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:[self hashOfImageName:imageName]];
    
    if (![[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil]) {
        NSLog(@"[PPAsyncImageLoader] Failed to create the cache file named %@ at %@", imageName, filePath);
    }
}

- (UIImage *)readImageFromCacheDirectoryWithImageName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSString *cacheDirectory = [cachePath stringByAppendingPathComponent:@"PPAsyncImageViewCaches"];
    
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:[self hashOfImageName:imageName]];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [UIImage imageWithData:data];
}

- (void)clearCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSString *cacheDirectory = [cachePath stringByAppendingPathComponent:@"PPAsyncImageViewCaches"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:cacheDirectory error:&error]) {
        NSLog(@"[PPAsyncImageLoader] Failed to remove the cache directory at %@, error: %@", cacheDirectory, error);
    }
}

@end
