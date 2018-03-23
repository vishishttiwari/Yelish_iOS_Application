//
//  ParseSignupViewController.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 23/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "ParseSignupViewController.h"

@interface ParseSignupViewController ()

@end

@implementation ParseSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    self.signUpView.logo = nil;
    [self.signUpView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.signUpView.signUpButton.backgroundColor = [UIColor colorWithRed:52.0f/255.0f green:191.0f/255.0f blue:73.0f/255.0f alpha:1];
    
    [self.signUpView.dismissButton setTintColor:[UIColor whiteColor]];
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgView.image = [UIImage imageNamed:@"background1.jpg"];
    [self.signUpView addSubview:imgView];
    [self.signUpView sendSubviewToBack:imgView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
