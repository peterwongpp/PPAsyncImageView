//
//  PPImageDataDownloader.m
//  PPAsyncImageViewDemo
//
//  Created by Peter Wong on 13/1/14.
//  Copyright (c) 2014 PPP. All rights reserved.
//

#import "PPImageDataDownloader.h"

@interface PPImageDataDownloader () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLRequest *urlRequest;
@property (nonatomic, strong) NSURLConnection *urlConnection;

@property (nonatomic, strong) NSURLResponse *urlResponse;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation PPImageDataDownloader

+ (void)loadWithURL:(NSURL *)url completionHandler:(void (^)(NSData *))completionHandler
{
    (void) [[PPImageDataDownloader alloc] initWithURL:url completionHandler:completionHandler];
}

- (id)initWithURL:(NSURL *)url completionHandler:(void (^)(NSData *))completionHandler
{
    if (self = [super init]) {
        self.url = url;
        self.completionHandler = completionHandler;
        
        self.urlRequest = [NSURLRequest requestWithURL:self.url];
        self.urlConnection = [NSURLConnection connectionWithRequest:self.urlRequest delegate:self];
    }
    return self;
}

#pragma mark -

#pragma mark NSURLConnectionDelegate

// TODO: handle authentication challenge?

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.completionHandler(nil);
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.urlResponse = response;
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.completionHandler(self.responseData);
}

@end
