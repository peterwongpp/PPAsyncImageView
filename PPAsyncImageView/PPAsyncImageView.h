//
//  PPAsyncImageView.h
//  PPAsyncImageViewDemo
//
//  Created by Peter Wong on 10/1/14.
//  Copyright (c) 2014 PPP. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    Posted when the image view will start loading the image.

    This notificaiton contains @c userInfo. The @c userInfo contains the key @c PPAsyncImageViewUserInfoKeyImageName for the image name that will be downloaded.
 
    @note If you set the image through the @c image property (e.g. [imageView setImage:...]), or set the @c imageName to @c nil, no @c PPAsyncImageViewWillLoadImageNotification will be posted.
*/
extern NSString *PPAsyncImageViewWillLoadImageNotification;
/**
    Posted when the image view finished loading the image.

    This notification contains @c userInfo. The @c userInfo contains the key @c PPAsyncImageViewUserInfoKeyImageName for the image name that is just downloaded, @c PPAsyncImageViewUserInfoKeyImage for the image downloaded, and @c PPAsyncImageViewUserInfoKeyDiscarded indicating if this image should be discarded or not.

    The image is considered discarded when, during the loading of an image, a new image name is given and causes another @c PPAsyncImageViewWillLoadImageNotification, then when the old image is loaded, the notification would have discarded be set to @c YES. And later the newly set image is loaded, the second @c PPAsyncImageViewDidLoadImageNotification will be posted with discarded set to @c NO.
 
    @note If you set the image through the @c image property (e.g. [imageView setImage:...]), or set the @c imageName to @c nil, no @c PPAsyncImageViewDidLoadImageNotification will be posted.
 */
extern NSString *PPAsyncImageViewDidLoadImageNotification;

extern NSString *PPAsyncImageViewUserInfoKeyImageName;
extern NSString *PPAsyncImageViewUserInfoKeyImage;
extern NSString *PPAsyncImageViewUserInfoKeyDiscarded;

/**
    A subclass of @c UIImageView which can load image from URL asynchronously, with activity indicator on top.
 */
@interface PPAsyncImageView : UIImageView

@property (nonatomic, assign, readonly) BOOL isImageLoading;
@property (nonatomic, assign, readonly) BOOL isImageLoaded;

/**
    Gets or sets the imageName and download the image immediately if needed.
    To defer the downloading of the image, use @c -[setImageName:loadImmediately:] instead.
    Could be a local file name or an URL.
 */
@property (nonatomic, strong) NSString *imageName;

/**
    Sets the imageName and optioanlly ask to download the image immediately or not.

    @note If you pass @c NO to @c loadImmediately, no image will be provided even the imageName is a local file name or already cached, until the -[start] method is called explicitly, see below.

    @code
    PPAsyncImageView *imageView = ...;
    [imageView setImageName@"http://example.com/some.png" loadImmediately:NO];
    ...
    [imageView start];
    @endcode

    @param imageName the name or URL of the image.
    @param loadImmediately whether load the image immediately or not.
 */
- (void) setImageName:(NSString *)imageName loadImmediately:(BOOL)loadImmediately;

/**
    Starts downloading the image. No effect if the downloading process is already started or finished.
 */
- (void) start;

@end
