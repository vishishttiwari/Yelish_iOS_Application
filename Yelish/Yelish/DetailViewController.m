//
//  DetailViewController.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 28/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import "DetailViewController.h"
@import AVFoundation;

@interface DetailViewController ()
@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;
@end

@implementation DetailViewController

BOOL likes1Visible;
BOOL likes2Visible;
BOOL video;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController setNavigationBarHidden: YES];
    
    [self.view sendSubviewToBack:self.gradientView];
    [self.view sendSubviewToBack:self.gradientView2];
    [self.view sendSubviewToBack:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:swipeRight];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tap];
    
    self.views.hidden = YES;
    self.likes.hidden = YES;
    self.postedBy.hidden = YES;
    self.createdAt.hidden = YES;
    self.flagButton.hidden = YES;
    self.thrashButton.hidden = YES;
    self.gradientView.hidden = YES;
    self.gradientView2.hidden = YES;
    self.video.hidden = YES;
    likes1Visible = false;
    likes2Visible = false;
    video = false;
    
    [self showImageAtIndex:self.currentIndex];
}

-(void)showImageAtIndex:(NSInteger)index
{
    video = false;
    self.imageObject = [self.photos objectAtIndex:index];
    [self.avPlayer pause];
    [self.avPlayerLayer removeFromSuperlayer];
    self.avPlayer = nil;
    self.imageView.image = nil;
    if ([[self.imageObject objectForKey:@"fileType"] isEqualToString:@"image"]) {
        PFFile *imageFile = [self.imageObject objectForKey:@"file"];
        [imageFile getDataInBackgroundWithBlock:^(NSData * data, NSError * error) {
        if (!error) {
            [self.imageView setImage:[UIImage imageWithData:data]];
        }
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        }];
    }
    else {
        video = true;
        PFFile *imageFile = [self.imageObject objectForKey:@"fileThumbnail"];
        [imageFile getDataInBackgroundWithBlock:^(NSData * data, NSError * error) {
            if (!error) {
                [self.imageView setImage:[UIImage imageWithData:data]];
            }
            [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        }];
        PFFile *videoFile = [self.imageObject objectForKey:@"file"];
        NSURL *url = [NSURL URLWithString:videoFile.url];
        // the video player
        self.avPlayer = [AVPlayer playerWithURL:url];
//        self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
        //self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.avPlayer currentItem]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemStalled:)
                                                     name:AVPlayerItemPlaybackStalledNotification
                                                   object:[self.avPlayer currentItem]];
        self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.imageView.layer addSublayer:self.avPlayerLayer];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
        self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [self.avPlayer play];
    }
    
    __block BOOL a = NO;
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    
    [query getObjectInBackgroundWithId:self.imageObject.objectId block:^(PFObject *posts, NSError *error) {
        [posts incrementKey:@"views1"];
        [posts incrementKey:@"Value"];
        [self.views setText:[NSString stringWithFormat:@"Views: %@", posts[@"views1"]]];
        [self.likes setText:[NSString stringWithFormat:@"Likes: %@", posts[@"likes"]]];
        [self.postedBy setText:[NSString stringWithFormat:@"Posted By: %@", posts[@"senderName"]]];
        NSDate *updated = [posts createdAt];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM d, h:mm a"];
        [self.createdAt setText:[NSString stringWithFormat:@"Posted At: %@", [dateFormat stringFromDate:updated]]];
        [self.postedBy setTextAlignment:NSTextAlignmentLeft];
        
        [posts saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The score key has been incremented
            } else {
                NSLog(@"The view count was not incremented");
            }
        }];
        PFQuery *query1 = [PFQuery queryWithClassName:@"Like"];
        [query1 whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [query1 whereKey:@"toPost" equalTo:posts];
        [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            PFObject *first = [objects objectAtIndex:0];
            if ((first = [PFUser currentUser])) {
                [self.likeButton setSelected:YES];
                a = YES;
            }
        }];
    }];
    likes2Visible = true;
    if (likes1Visible && likes2Visible) {
        self.likeButton.hidden = NO;
    }
    else {
        self.likeButton.hidden = YES;
    }
    if (a == NO) {
        [self.likeButton setSelected:NO];
    }
}

-(void)swipeImage:(UISwipeGestureRecognizer*)recognizer
{
    NSInteger index = self.currentIndex;
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        index++;
        if (index > ([self.photos count] - 1)) {
            index = ([self.photos count]);
        }
        else {
            CATransition *animation = [CATransition animation];
            [animation setDelegate:self];
            [animation setType:kCATransitionPush];
            [animation setSubtype:kCATransitionFromRight];
            [animation setDuration:0.20];
            [animation setTimingFunction:
             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [self.imageView.layer addAnimation:animation forKey:kCATransition];
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        index--;
        if (index < 0) {
            index = -1;
        }
        else {
            CATransition *animation = [CATransition animation];
            [animation setDelegate:self];
            [animation setType:kCATransitionPush];
            [animation setSubtype:kCATransitionFromLeft];
            [animation setDuration:0.20];
            [animation setTimingFunction:
             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [self.imageView.layer addAnimation:animation forKey:kCATransition];
        }
    }
    if (index >= 0 && index <= ([self.photos count] - 1))
    {
        [self.views setText:[NSString stringWithFormat:@""]];
        [self.likes setText:[NSString stringWithFormat:@""]];
        [self.postedBy setText:[NSString stringWithFormat:@""]];
        [self.createdAt setText:[NSString stringWithFormat:@""]];
        if (likes1Visible && self.integerValue == 0) {
            self.flagButton.hidden = NO;
            self.thrashButton.hidden = YES;
        }
        else if (likes1Visible && self.integerValue == 1) {
            self.flagButton.hidden = YES;
            self.thrashButton.hidden = NO;
        }
        else {
            self.flagButton.hidden = YES;
            self.thrashButton.hidden = YES;
        }
        likes2Visible = false;
        if (likes1Visible && likes2Visible) {
            self.likeButton.hidden = NO;
        }
        else {
            self.likeButton.hidden = YES;
        }
        
        self.currentIndex = index;
        [self showImageAtIndex:self.currentIndex];
    }
    else
    {
        NSLog(@"Reached the end, swipe in opposite direction");
    }
    if (video == true) {
        self.video.hidden = NO;
        NSLog(@"true");
    } else {
        self.video.hidden = YES;
        NSLog(@"false");
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)recognizer
{
    if (!self.views.hidden) {
        self.views.hidden = YES;
        self.likes.hidden = YES;
        self.postedBy.hidden = YES;
        self.createdAt.hidden = YES;
        self.flagButton.hidden = YES;
        self.thrashButton.hidden = YES;
        self.gradientView.hidden = YES;
        self.gradientView2.hidden = YES;
        self.video.hidden = YES;
        likes1Visible = false;
    }
    else {
        self.views.hidden = NO;
        self.likes.hidden = NO;
        self.postedBy.hidden = NO;
        self.createdAt.hidden = NO;
        if (video == true) {
            self.video.hidden = NO;
        }
        if (self.integerValue == 0) {
            self.flagButton.hidden = NO;
            self.thrashButton.hidden = YES;
        }
        else if (self.integerValue == 1) {
            self.flagButton.hidden = YES;
            self.thrashButton.hidden = NO;
        }
        self.gradientView.hidden = NO;
        self.gradientView2.hidden = NO;
        likes1Visible = true;
    }
    if (likes1Visible && likes2Visible) {
        self.likeButton.hidden = NO;
    }
    else {
        self.likeButton.hidden = YES;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)close:(id)sender {
    [self.navigationController setNavigationBarHidden: NO];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)like:(id)sender {
    if(self.likeButton.selected) {
        [self.likeButton setSelected:NO];
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Posts"];
        [query1 getObjectInBackgroundWithId:self.imageObject.objectId block:^(PFObject *posts, NSError *error) {
            [posts incrementKey:@"likes" byAmount:[NSNumber numberWithInt:-1]];
            [posts incrementKey:@"Value" byAmount:[NSNumber numberWithInt:-5]];
            [posts saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"The like count was incremented");
                } else {
                    NSLog(@"The like count was not incremented");
                }
            }];
            [self.likes setText:[NSString stringWithFormat:@"Likes: %@", posts[@"likes"]]];
            PFQuery *query = [PFQuery queryWithClassName:@"Like"];
            [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
            [query whereKey:@"toPost" equalTo:posts];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                for (PFObject *object in objects) {
                    [object deleteInBackground];
                }
            }];
        }];
    }
    else {
        [self.likeButton setSelected:YES];
        
        PFObject *like = [PFObject objectWithClassName:@"Like"];
        [like setObject:[PFUser currentUser] forKey:@"fromUser"];
        PFObject *object = [PFObject objectWithoutDataWithClassName:@"Posts"objectId:self.imageObject.objectId];
        [like setObject:object forKey:@"toPost"];
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Posts"];
        [query1 getObjectInBackgroundWithId:self.imageObject.objectId block:^(PFObject *posts, NSError *error) {
            
            [posts incrementKey:@"likes"];
            [posts incrementKey:@"Value" byAmount:[NSNumber numberWithInt:5]];
            [posts saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"The like count was decremented");
                } else {
                    NSLog(@"The like count was not decremented");
                }
            }];
            [self.likes setText:[NSString stringWithFormat:@"Likes: %@", posts[@"likes"]]];
        }];
        
        [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"An error occurred!" message:@"Please try liking the post again." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertView addAction:ok];
                
                [self presentViewController:alertView animated:true completion:nil];
            }
            else {
                // Everything was successful!
            }
        }];
    }
}

- (IBAction)flag:(id)sender {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Report the Post?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction* flag = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        PFObject *like = [PFObject objectWithClassName:@"FlaggedContent"];
        [like setObject:[PFUser currentUser] forKey:@"fromUser"];
        PFObject *object = [PFObject objectWithoutDataWithClassName:@"Posts"objectId:self.imageObject.objectId];
        [like setObject:object forKey:@"toPost"];
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Posts"];
        [query1 getObjectInBackgroundWithId:self.imageObject.objectId block:^(PFObject *posts, NSError *error) {
            [posts incrementKey:@"flagged"];
            [posts saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"The flag count was incremented");
                } else {
                    NSLog(@"The flag count was not incremented");
                }
            }];
        }];
        [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"An error occurred!" message:@"Please flag the post again." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertView addAction:ok];
                
                [self presentViewController:alertView animated:true completion:nil];
            }
            else {
                // Everything was successful!
            }
        }];
    }];
    [alertView addAction:cancel];
    [alertView addAction:flag];
    
    [self presentViewController:alertView animated:true completion:nil];
/*
    if(self.flagButton.selected) {
        [self.flagButton setSelected:NO];
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Posts"];
        [query1 getObjectInBackgroundWithId:self.imageObject.objectId block:^(PFObject *posts, NSError *error) {
            [posts incrementKey:@"flagged" byAmount:[NSNumber numberWithInt:-1]];
            [posts saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"The flag count was decremented");
                } else {
                    NSLog(@"The flag count was not decremented");
                }
            }];
            
            PFQuery *query = [PFQuery queryWithClassName:@"FlaggedContent"];
            [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
            [query whereKey:@"toPost" equalTo:posts];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                for (PFObject *object in objects) {
                    [object deleteInBackground];
                }
            }];
        }];
    }
    
    else {
        [self.flagButton setSelected:YES];
        
        PFObject *like = [PFObject objectWithClassName:@"FlaggedContent"];
        [like setObject:[PFUser currentUser] forKey:@"fromUser"];
        PFObject *object = [PFObject objectWithoutDataWithClassName:@"Posts"objectId:self.imageObject.objectId];
        [like setObject:object forKey:@"toPost"];
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Posts"];
        [query1 getObjectInBackgroundWithId:self.imageObject.objectId block:^(PFObject *posts, NSError *error) {
            
            [posts incrementKey:@"flagged"];
            [posts saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"The flag count was incremented");
                } else {
                    NSLog(@"The flag count was not incremented");
                }
            }];
        }];
        
        [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"An error occurred!" message:@"Please flag the post again." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertView addAction:ok];
                
                [self presentViewController:alertView animated:true completion:nil];
            }
            else {
                // Everything was successful!
            }
        }];
    }
 */
}
- (IBAction)thrash:(id)sender {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Delete Your Post?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Posts"];
        [query1 getObjectInBackgroundWithId:self.imageObject.objectId block:^(PFObject *posts, NSError *error) {
            [posts deleteInBackground];
            PFQuery *query = [PFQuery queryWithClassName:@"Like"];
            query.cachePolicy = kPFCachePolicyNetworkOnly;
            [query whereKey:@"toPost" equalTo:posts];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (int i = 0; i < [objects count]; i++) {
                    [[objects objectAtIndex:i] deleteInBackground];
                }
            }];
            if (self.currentIndex < ([self.photos count] - 1)) {
                [self.photos removeObjectAtIndex:self.currentIndex];
                self.currentIndex = self.currentIndex;
                [self showImageAtIndex:self.currentIndex];
            }
            else if (self.currentIndex > 0) {
                [self.photos removeObjectAtIndex:self.currentIndex];
                self.currentIndex = self.currentIndex - 1;
                [self showImageAtIndex:self.currentIndex];
            }
            else {
                [self.photos removeObjectAtIndex:self.currentIndex];
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController setNavigationBarHidden: NO];
            }
        }];
    }];
    
    [alertView addAction:cancel];
    [alertView addAction:delete];
    
    [self presentViewController:alertView animated:true completion:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [self.avPlayer play];
}

- (void)playerItemStalled:(NSNotification *)notification {
    [self performSelector:@selector(continueVideo:) withObject:nil afterDelay:3];
}

- (void)continueVideo:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:self.avPlayer.currentTime];
    [self.avPlayer play];
}


@end
