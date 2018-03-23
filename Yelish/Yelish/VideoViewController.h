//
//  TestVideoViewController.h
//  Memento
//
//  Created by Ömer Faruk Gül on 22/05/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewUtils.h"
#import "UIImage+Crop.h"
#import "CameraTableViewController.h"

@interface VideoViewController : UIViewController

@property (strong, nonatomic) NSURL *videoUrl;

@end
