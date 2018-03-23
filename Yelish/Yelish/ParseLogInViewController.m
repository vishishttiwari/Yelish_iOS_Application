//
//  ParseLogInViewController.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 22/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "ParseLogInViewController.h"

@interface ParseLogInViewController ()

@end

@implementation ParseLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.logInView.logo = nil;
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.logInView.logInButton.backgroundColor = [UIColor colorWithRed:52.0f/255.0f green:191.0f/255.0f blue:73.0f/255.0f alpha:1];
    
    [self.logInView.passwordForgottenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.logInView.facebookButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.logInView.facebookButton.backgroundColor = [UIColor clearColor];
    self.logInView.facebookButton.layer.cornerRadius = 5.0f;
    self.logInView.facebookButton.layer.borderWidth = 1.0f;
    self.logInView.facebookButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.logInView.twitterButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.logInView.twitterButton.backgroundColor = [UIColor clearColor];
    self.logInView.twitterButton.layer.cornerRadius = 5.0f;
    self.logInView.twitterButton.layer.borderWidth = 1.0f;
    self.logInView.twitterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.logInView.signUpButton.backgroundColor = [UIColor clearColor];
    self.logInView.signUpButton.layer.cornerRadius = 5.0f;
    self.logInView.signUpButton.layer.borderWidth = 1.0f;
    self.logInView.signUpButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgView.image = [UIImage imageNamed:@"background.jpg"];
    [self.logInView addSubview:imgView];
    [self.logInView sendSubviewToBack:imgView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
