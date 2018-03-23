//
//  NearbyViewCell.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 24/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import "NearbyViewCell.h"

@interface NearbyViewCell ()

@property (nonatomic) CGFloat parallaxOffset;
@property (nonatomic, strong) NSLayoutConstraint *imageViewCenterYConstraint;

@end
@implementation NearbyViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        self.locationImage = [[PFImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.locationImage.frame = self.contentView.bounds;
        self.locationImage.contentMode = UIViewContentModeScaleAspectFill;
        
        self.gradientView = [[GradientView alloc] init];
        self.gradientView.frame = self.contentView.bounds;
        self.gradientView.contentMode = UIViewContentModeScaleToFill;

        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (frame.size.height - 80.0), frame.size.width, frame.size.height/4)];
        self.locationLabel.numberOfLines = 0;
        self.locationLabel.textAlignment = NSTextAlignmentCenter;
        self.locationLabel.textColor = [UIColor whiteColor];
        self.locationLabel.backgroundColor = [UIColor clearColor];

        
        self.otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (frame.size.height - 40.0), frame.size.width, 50.0)];
        self.otherLabel.textAlignment = NSTextAlignmentCenter;
        self.otherLabel.textColor = [UIColor whiteColor];
        self.otherLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.locationImage];
        [self.contentView addSubview:self.gradientView];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.otherLabel];
        
//        [self setupConstraints];
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.locationImage.image = nil;
}
/*
- (void)setupConstraints
{
    self.locationImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Vertical constraints for image view
    self.imageViewCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.locationImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:self.imageViewCenterYConstraint];
}

- (void)updateParallaxOffset:(CGRect)bounds {
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGPoint offsetFromCenter = CGPointMake(center.x - self.center.x, center.y - self.center.y);
    CGFloat maxVerticalOffset = (CGRectGetHeight(bounds) / 2) + (CGRectGetHeight(self.bounds) / 2);
    CGFloat scaleFactor = 60 / maxVerticalOffset;
    
    self.parallaxOffset = -offsetFromCenter.y * scaleFactor;
    
    self.imageViewCenterYConstraint.constant = self.parallaxOffset;
}
 */
@end
