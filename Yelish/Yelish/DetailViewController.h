//
//  DetailViewController.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 28/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GradientView1.h"
#import "GradientView2.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewUtils.h"
#import "UIImage+Crop.h"

@interface DetailViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) PFObject *imageObject;
@property (nonatomic) NSNumber *viewsValue;
@property (nonatomic) NSInteger integerValue;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet GradientView1 *gradientView;
@property (strong, nonatomic) IBOutlet GradientView2 *gradientView2;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *flagButton;
@property (strong, nonatomic) IBOutlet UIButton *thrashButton;
@property (strong, nonatomic) IBOutlet UILabel *views;
@property (strong, nonatomic) IBOutlet UILabel *likes;
@property (strong, nonatomic) IBOutlet UILabel *postedBy;
@property (strong, nonatomic) IBOutlet UILabel *createdAt;
@property (strong, nonatomic) IBOutlet UIImageView *video;


- (IBAction)close:(id)sender;
- (IBAction)like:(id)sender;
- (IBAction)flag:(id)sender;
- (IBAction)thrash:(id)sender;
@end
