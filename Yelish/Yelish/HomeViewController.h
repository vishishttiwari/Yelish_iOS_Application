//
//  HomeViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"

@interface HomeViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *outputFileUrl;

@end
