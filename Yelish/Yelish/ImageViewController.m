//
//  ImageViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *forwardButton;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    NSString *info = [NSString stringWithFormat:@"Size: %@  -  Orientation: %ld", NSStringFromCGSize(self.image.size), (long)self.image.imageOrientation];
    
    NSLog(@"%@", info);
    
    // button to save
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.saveButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    self.saveButton.tintColor = [UIColor whiteColor];
    [self.saveButton setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    
    // button to upload
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.forwardButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    self.forwardButton.tintColor = [UIColor whiteColor];
    [self.forwardButton setImage:[UIImage imageNamed:@"speaker.png"] forState:UIControlStateNormal];
    [self.forwardButton addTarget:self action:@selector(forwardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forwardButton];
    
    // button to close
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    self.cancelButton.tintColor = [UIColor whiteColor];
    [self.cancelButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];

}

- (void)closeButtonPressed:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)saveButtonPressed:(UIButton *)button
{
    UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.infoLabel.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.text = @"Saved to Library!";
    [self.view addSubview:self.infoLabel];
}

- (void)forwardButtonPressed:(UIButton *)button
{
    [self performSegueWithIdentifier:@"uploadImage" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"uploadImage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        CameraTableViewController *cameraTableViewController = (CameraTableViewController *)segue.destinationViewController;
        cameraTableViewController.image = self.image;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.infoLabel sizeToFit];
    self.infoLabel.width = self.view.contentBounds.size.width;
    self.infoLabel.top = 0;
    self.infoLabel.left = 0;
    
    self.imageView.frame = self.view.contentBounds;
    
    self.cancelButton.top = 5.0f;
    self.cancelButton.left = 5.0f;
    
    self.forwardButton.bottom = self.imageView.height - 25.0f;
    self.forwardButton.right = self.imageView.width - 12.0f;
    
    self.saveButton.left = 12.0f;
    self.saveButton.bottom = self.imageView.height - 25.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
