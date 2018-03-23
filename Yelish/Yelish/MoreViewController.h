//
//  MoreViewController.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 25/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyViewController.h"
#import "SearchViewController.h"

@interface MoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (strong, nonatomic) IBOutlet UITableView *tableView2;
@property (strong, nonatomic) IBOutlet UILabel *kms;

@property (strong, nonatomic) NearbyViewController *nearbyViewController;
@property (strong, nonatomic) SearchViewController *searchViewController;

- (IBAction)sliderValue:(UISlider *)sender;
- (IBAction)minus:(id)sender;
- (IBAction)plus:(id)sender;
@end
