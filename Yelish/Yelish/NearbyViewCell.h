//
//  NearbyViewCell.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 24/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "GradientView.h"

@interface NearbyViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *otherLabel;
@property (strong, nonatomic) IBOutlet PFImageView *locationImage;
@property (strong, nonatomic) IBOutlet GradientView *gradientView;

- (void)updateParallaxOffset:(CGRect)bounds;
- (void)backGroundMotion;

@end
