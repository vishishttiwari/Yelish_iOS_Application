//
//  CameraTableViewController.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 23/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraTableViewController : UITableViewController <UINavigationControllerDelegate,  UIImagePickerControllerDelegate>

// Property for camera.
@property (nonatomic, strong) UIImagePickerController *imagePicker;
// Image property.
@property (nonatomic, strong) UIImage *image;
// Because video is saved as the file URL so it is a path.
@property (nonatomic, strong) NSURL *videoFilePath;
// Array to hold on the locations.
@property (nonatomic, strong) NSMutableArray *allLocations;
// Array to hold on the addresses.
@property (nonatomic, strong) NSMutableArray *allAddresses;
// Array to hold on the PlaceIds.
@property (nonatomic, strong) NSMutableArray *allPlaceIds;
// Array to hold on the latitudes.
@property (nonatomic, strong) NSMutableArray *allLatitudes;
// Array to hold on the longitudes.
@property (nonatomic, strong) NSMutableArray *allLongitudes;
// Location selected by the user.
@property (nonatomic, strong) NSString *locationSelected;
// Id of the Location selected by the user.
@property (nonatomic, strong) NSString *locationIdSelected;
// Latitude of the Location selected by the user.
@property (nonatomic, strong) NSNumber *latitudeSelected;
// Longitude of the Location selected by the user.
@property (nonatomic, strong) NSNumber *longitudeSelected;

// IBAction for cancelling the post.
- (IBAction)cancel:(id)sender;
// IBAction for posting the post.
- (IBAction)post:(id)sender;

// What will be uploaded
- (void)uploadPost;
// function for returning the resized image.
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end
