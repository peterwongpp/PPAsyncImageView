//
//  PPViewController.m
//  PPAsyncImageViewDemo
//
//  Created by Peter Wong on 10/1/14.
//  Copyright (c) 2014 PPP. All rights reserved.
//

#import "PPViewController.h"
#import "PPAsyncImageView.h"

#define kAsyncImageViewTag 123321

@interface PPViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation PPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    self.imageViews = [NSMutableArray array];
    NSArray *imageNames = @[
                            @"Logo-PPP",
                            @"http://example.com/not-exist-sadkjfjkhdsafg.jpg", // This image will fail
                            @"https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-frc3/t1/s720x720/316444_10150308148597665_1538822882_n.jpg"
                            ];
    
    for (NSString *imageName in imageNames) {
        PPAsyncImageView *imageView = [[PPAsyncImageView alloc] initWithFrame:(CGRect){0, 0, 44, 44}];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImageName:imageName loadImmediately:NO];
        [imageView setTag:kAsyncImageViewTag];
        [self.imageViews addObject:imageView];
    }
    
    // Special case for setting imageName to nil.
    PPAsyncImageView *imageView = [[PPAsyncImageView alloc] initWithFrame:(CGRect){0, 0, 44, 44}];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImageName:nil loadImmediately:NO];
    [imageView setTag:kAsyncImageViewTag];
    [self.imageViews addObject:imageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView setFrame:self.view.frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.imageViews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"AsyncImageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    PPAsyncImageView *previousImageView = (PPAsyncImageView *)[cell.contentView viewWithTag:kAsyncImageViewTag];
    [previousImageView removeFromSuperview];
    
    PPAsyncImageView *imageView = self.imageViews[indexPath.row];
    [imageView start];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

@end
