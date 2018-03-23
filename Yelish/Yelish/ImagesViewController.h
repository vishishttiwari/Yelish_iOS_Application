//
//  ImagesViewController.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 15/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ImagesViewCell.h"
#import "DetailViewController.h"
#import "ImagesFlowLayout.h"
#import "ImagesReusableView.h"
#import "Annotation.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface ImagesViewController : UICollectionViewController

@property (strong, nonatomic) NSString *selectedLocation;
@property (strong, nonatomic) NSString *selectedLocationId;

@property (strong, nonatomic) NSArray *imagesByDate;
@property (strong, nonatomic) NSArray *imagesByValue;

@property (strong, nonatomic) NSArray *filesByDate;
@property (strong, nonatomic) NSArray *filesByValue;

@property (strong, nonatomic) NSArray *thumbnailByDate;
@property (strong, nonatomic) NSArray *thumbnailByValue;

@property (strong, nonatomic) NSArray *formatByDate;
@property (strong, nonatomic) NSArray *formatByValue;

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic) CGFloat previousScrollViewYOffset;

@property (nonatomic) double span;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSArray *coordinate;

@property (nonatomic) NSInteger segmentedControl;

@end
