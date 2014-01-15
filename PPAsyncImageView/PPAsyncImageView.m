//
//  PPAsyncImageView.m
//  PPAsyncImageViewDemo
//
//  Created by Peter Wong on 10/1/14.
//  Copyright (c) 2014 PPP. All rights reserved.
//

#import "PPAsyncImageView.h"
#import "PPImageLoader.h"

NSString *PPAsyncImageViewWillLoadImageNotification     = @"PPAsyncImageViewWillLoadImageNotificationKey";
NSString *PPAsyncImageViewDidLoadImageNotification      = @"PPAsyncImageViewDidLoadImageNotificationKey";

NSString *PPAsyncImageViewUserInfoKeyImageName  = @"PPAsyncImageViewUserInfoKeyImageNameKey";
NSString *PPAsyncImageViewUserInfoKeyImage      = @"PPAsyncImageViewUserInfoKeyImage";
NSString *PPAsyncImageViewUserInfoKeyDiscarded  = @"PPAsyncImageViewUserInfoKeyDiscarded";

@interface PPAsyncImageView ()

@property (nonatomic, strong) NSString *loadingImageName;
@property (nonatomic, assign) BOOL isImageLoaded;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (void) resetState;

- (void) postWillLoadNotificationWithImageName:(NSString *)imageName;
- (void) postDidLoadNotificationWithImageName:(NSString *)imageName image:(UIImage *)image discarded:(BOOL)discarded;

@end

@implementation PPAsyncImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityIndicatorView setCenter:[self center]];
        [self.activityIndicatorView stopAnimating];
        [self addSubview:self.activityIndicatorView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.activityIndicatorView setCenter:[self center]];
}

- (BOOL)isImageLoading
{
    return [self.activityIndicatorView isAnimating];
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    [self setIsImageLoaded:YES];
    [self.activityIndicatorView stopAnimating];
}

- (void)setImageName:(NSString *)imageName
{
    [self setImageName:imageName loadImmediately:YES];
}

- (void)setImageName:(NSString *)imageName loadImmediately:(BOOL)loadImmediately
{
    _imageName = imageName;
    
    [self resetState];
    
    if (loadImmediately) {
        [self start];
    }
}

- (void)start
{
    if (self.isImageLoading || self.isImageLoaded) {
        return;
    }
    
    [self setIsImageLoaded:NO];
    [self setLoadingImageName:self.imageName];
    [self postWillLoadNotificationWithImageName:self.imageName];
    [self.activityIndicatorView startAnimating];
    [[PPImageLoader sharedInstance] loadImageNamed:self.loadingImageName completion:^(NSString *imageName, UIImage *image){
        BOOL discarded = YES;
        if ([imageName isEqual:self.loadingImageName] && !self.isImageLoaded) { // isImageLoaded may be set to YES during the downloading, when another UIImage * is set directly through -[self setImage:] method.
            discarded = NO;
            [self setIsImageLoaded:YES];
            [self setLoadingImageName:nil];
            [super setImage:image];
            [self.activityIndicatorView stopAnimating];
        }
        [self postDidLoadNotificationWithImageName:imageName image:image discarded:discarded];
    }];
}

- (void)resetState
{
    [self setIsImageLoaded:NO];
    [self setLoadingImageName:nil];
    
    [super setImage:nil];
    [self.activityIndicatorView stopAnimating];
}

#pragma mark -

#pragma mark Notification

- (void)postWillLoadNotificationWithImageName:(NSString *)imageName
{
    NSDictionary *userInfo = @{
                               PPAsyncImageViewUserInfoKeyImageName: imageName
                               };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PPAsyncImageViewWillLoadImageNotification object:self userInfo:userInfo];
}

- (void)postDidLoadNotificationWithImageName:(NSString *)imageName image:(UIImage *)image discarded:(BOOL)discarded
{
    NSDictionary *userInfo = @{
                               PPAsyncImageViewUserInfoKeyImageName: imageName,
                               PPAsyncImageViewUserInfoKeyImage: image,
                               PPAsyncImageViewUserInfoKeyDiscarded: @(discarded)
                               };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PPAsyncImageViewDidLoadImageNotification object:self userInfo:userInfo];
}

@end
