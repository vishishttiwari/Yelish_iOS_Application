//
//  TestVideoViewController.m
//  Memento
//
//  Created by Ömer Faruk Gül on 22/05/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import "VideoViewController.h"
@import AVFoundation;

@interface VideoViewController ()
@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *forwardButton;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UILabel *infoLabel;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // the video player
    self.avPlayer = [AVPlayer playerWithURL:self.videoUrl];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    //self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    
    [self.view.layer addSublayer:self.avPlayerLayer];
    self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.avPlayer play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)closeButtonPressed:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)saveButtonPressed:(UIButton *)button
{
    // Save the video!
    BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([self.videoUrl path]);
    
    // save
    if (compatible){
        UISaveVideoAtPathToSavedPhotosAlbum([self.videoUrl path], self, nil, NULL);
        NSLog(@"saved!!!! %@",[self.videoUrl path]);
    }
        
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
    [self performSegueWithIdentifier:@"uploadVideo" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"uploadVideo"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        CameraTableViewController *cameraTableViewController = (CameraTableViewController *)segue.destinationViewController;
        cameraTableViewController.videoFilePath = self.videoUrl;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.infoLabel sizeToFit];
    self.infoLabel.width = self.view.contentBounds.size.width;
    self.infoLabel.top = 0;
    self.infoLabel.left = 0;
    
    CGRect frame = _infoLabel.frame;
    frame.origin.y=0;//pass the cordinate which you want
    frame.origin.x= 0;//pass the cordinate which you want
    _infoLabel.frame= frame;
    
    CGRect frame1 = _cancelButton.frame;
    frame1.origin.y=5.0f;//pass the cordinate which you want
    frame1.origin.x= 5.0f;//pass the cordinate which you want
    _cancelButton.frame= frame1;
    
    CGRect frame2 = _forwardButton.frame;
    frame2.origin.y= [[UIScreen mainScreen] bounds].size.height - 55.0f;//pass the cordinate which you want
    frame2.origin.x= [[UIScreen mainScreen] bounds].size.width - 52.0f;//pass the cordinate which you want
    _forwardButton.frame= frame2;
    
    CGRect frame3 = _saveButton.frame;
    frame3.origin.y= [[UIScreen mainScreen] bounds].size.height - 55.0f;//pass the cordinate which you want
    frame3.origin.x= 12.0f;//pass the cordinate which you want
    _saveButton.frame= frame3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
