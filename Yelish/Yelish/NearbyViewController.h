//
//  NearbyViewController.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 22/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "NearbyViewCell.h"
#import "ParseLogInViewController.h"
#import "ParseSignupViewController.h"
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import <ParseTwitterUtils/ParseTwitterUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ImagesViewController.h"
#import "LocationFlowLayout.h"

@interface NearbyViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *locationsInformation;

@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSMutableArray *locationIds;
@property (nonatomic, strong) NSMutableArray *modifiedLocations;
@property (nonatomic, strong) NSMutableArray *modifiedLocationIds;
@property (nonatomic, strong) NSMutableArray *moreModifiedLocations;
@property (nonatomic, strong) NSMutableArray *moreModifiedLocationIds;

@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSMutableArray *modifiedViews;
@property (nonatomic, strong) NSMutableArray *moreModifiedViews;

@property (nonatomic, strong) NSMutableArray *likes;
@property (nonatomic, strong) NSMutableArray *modifiedLikes;
@property (nonatomic, strong) NSMutableArray *moreModifiedLikes;

@property (nonatomic, strong) NSMutableArray *frequency;
@property (nonatomic, strong) NSMutableArray *sum;

@property (nonatomic, strong) NSString *selectedLocationId;
@property (nonatomic, strong) NSString *selectedLocation;

@property (nonatomic, strong) NSArray *popularImages;
@property (nonatomic, strong) NSArray *popularImagesLocations;

@property (nonatomic, strong) PFFile *imageObject;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic) CGFloat previousScrollViewYOffset;

@property (nonatomic) int kms;

@end
