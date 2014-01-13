//
//  PPAsyncImageView.h
//  PPAsyncImageViewDemo
//
//  Created by Peter Wong on 10/1/14.
//  Copyright (c) 2014 PPP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *PPAsyncImageViewWillLoadImageNotification;
extern NSString *PPAsyncImageViewDidLoadImageNotification;

@interface PPAsyncImageView : UIImageView

@property (nonatomic, assign, readonly) BOOL isImageLoading;

// imageName can be either a local file name or an URL
@property (nonatomic, strong) NSString *imageName;

- (void) setImageName:(NSString *)imageName loadImmediately:(BOOL)loadImmediately;
- (void) start;

@end
