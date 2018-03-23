//
//  SearchViewCell.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 31/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import "SearchViewCell.h"

@interface SearchViewCell ()

@property (nonatomic) CGFloat parallaxOffset;
@property (nonatomic, strong) NSLayoutConstraint *imageViewCenterYConstraint;

@end

@implementation SearchViewCell

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
        self.otherLabel.backgroundColor = [UIColor clearColor];
        
        
        self.otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (frame.size.height - 40.0), frame.size.width, 50.0)];
        self.otherLabel.textAlignment = NSTextAlignmentCenter;
        self.otherLabel.textColor = [UIColor whiteColor];
        self.otherLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.locationImage];
        [self.contentView addSubview:self.gradientView];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.otherLabel];
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.locationImage.image = nil;
}

@end
