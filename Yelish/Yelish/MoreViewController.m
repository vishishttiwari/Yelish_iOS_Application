//
//  MoreViewController.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 25/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

static NSString * const reuseIdentifier = @"Cell";

NSArray *tableView1Data;
NSArray *tableView2Data;

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *navigationController1 = (UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:0];
    UINavigationController *navigationController2 = (UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:1];
    self.nearbyViewController = [navigationController1 topViewController];
    self.searchViewController = [navigationController2 topViewController];
    tableView1Data = [NSArray arrayWithObjects:@"Like us on Facebook", @"Follow us on Twitter", nil];
    tableView2Data = [NSArray arrayWithObjects:@"Terms & Conditions", nil];
    
    self.tableView1.alwaysBounceVertical = NO;
    self.tableView1.alwaysBounceHorizontal = NO;
    self.tableView1.scrollEnabled = NO;
    
    self.tableView2.alwaysBounceVertical = NO;
    self.tableView2.alwaysBounceHorizontal = NO;
    self.tableView2.scrollEnabled = NO;
    
    [self.tableView1 setDataSource:self];
    [self.tableView2 setDataSource:self];
    
    [self.tableView1 setDelegate:self];
    [self.tableView2 setDelegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView1) {
        return [tableView1Data count];
    }
    else if (tableView == self.tableView2) {
        return [tableView2Data count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        cell.textLabel.text = [tableView1Data objectAtIndex:indexPath.row];
        return cell;
    }
    else if (tableView == self.tableView2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = [tableView2Data objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView1) {
        if (indexPath.row == 0) {
            NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/1032906590129143"];
            if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
                [[UIApplication sharedApplication] openURL:facebookURL];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/yelishapp"]];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        else if (indexPath.row == 1) {
            NSURL *twitterURL = [NSURL URLWithString:@"twitter://status?screen_name=Yelishapp"];
            if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
                [[UIApplication sharedApplication] openURL:twitterURL];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Yelishapp"]];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    if (tableView == self.tableView2) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"showTC" sender:self];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

- (IBAction)sliderValue:(UISlider *)sender {
    self.kms.text = [NSString stringWithFormat:@"%i km", (int) sender.value];
    [self.nearbyViewController setKms:(int) sender.value];
    [self.searchViewController setKms:(int) sender.value];
}

- (IBAction)minus:(id)sender {
    [self.slider setValue:[self.slider value]-1];
    self.kms.text = [NSString stringWithFormat:@"%i km", (int) [self.slider value]];
    [self.nearbyViewController setKms:(int) [self.slider value]];
    [self.searchViewController setKms:(int) [self.slider value]];
}

- (IBAction)plus:(id)sender {
    [self.slider setValue:[self.slider value]+1];
    self.kms.text = [NSString stringWithFormat:@"%i km", (int) [self.slider value]];
    [self.nearbyViewController setKms:(int) [self.slider value]];
    [self.searchViewController setKms:(int) [self.slider value]];
}
@end