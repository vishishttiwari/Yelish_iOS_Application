//
//  ImageViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewUtils.h"
#import "UIImage+Crop.h"
#import "CameraTableViewController.h"

@interface ImageViewController : UIViewController

@property (strong, nonatomic) UIImage *image;

@end
