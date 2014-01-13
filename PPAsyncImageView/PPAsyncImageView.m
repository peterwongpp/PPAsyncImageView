//
//  PPAsyncImageView.m
//  PPAsyncImageViewDemo
//
//  Created by Peter Wong on 10/1/14.
//  Copyright (c) 2014 PPP. All rights reserved.
//

#import "PPAsyncImageView.h"
#import "PPImageLoader.h"

@interface PPAsyncImageView ()

@property (nonatomic, strong) NSString *loadingImageName;
@property (nonatomic, assign) BOOL isImageLoaded;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (void) resetState;

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

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    [self setIsImageLoaded:YES];
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
    if (self.isImageLoaded) {
        return;
    }
    
    [self setIsImageLoaded:NO];
    [self setLoadingImageName:self.imageName];
    [self.activityIndicatorView startAnimating];
    [[PPImageLoader sharedInstance] loadImageNamed:self.loadingImageName completion:^(NSString *imageName, UIImage *image){
        if ([imageName isEqual:self.loadingImageName]) {
            [self setIsImageLoaded:YES];
            [self setLoadingImageName:nil];
            [super setImage:image];
            [self.activityIndicatorView stopAnimating];
        }
    }];
}

- (void)resetState
{
    [self setIsImageLoaded:NO];
    [self setLoadingImageName:nil];
    
    [super setImage:nil];
    [self.activityIndicatorView stopAnimating];
}

@end
