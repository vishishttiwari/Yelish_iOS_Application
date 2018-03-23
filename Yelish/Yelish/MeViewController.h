//
//  MeViewController.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 21/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeFlowLayout.h"
#import <Parse/Parse.h>
#import "MeViewCell.h"
#import "DetailViewController.h"
#import "MeReusableView.h"
#import "ParseLogInViewController.h"
#import "ParseSignupViewController.h"
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseTwitterUtils/ParseTwitterUtils.h>
#import "Annotation.h"

@interface MeViewController : UICollectionViewController <MKMapViewDelegate> 

@property (nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSArray *imagesByName;
@property (strong, nonatomic) NSMutableArray *imagesByLike;

@property (strong, nonatomic) NSArray *postsByLike;

@property (strong, nonatomic) NSArray *filesByName;
@property (strong, nonatomic) NSArray *filesByLike;

@property (strong, nonatomic) NSArray *thumbnailByName;
@property (strong, nonatomic) NSArray *thumbnailByLike;

@property (strong, nonatomic) NSArray *formatByName;
@property (strong, nonatomic) NSArray *formatByLike;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *coordinate;
@property (nonatomic, strong) NSArray *latitudes;
@property (nonatomic, strong) NSArray *longitudes;

@property (nonatomic) NSInteger segmentedControl;

@property (nonatomic) NSInteger temp;

- (IBAction)logout:(id)sender;

@end
