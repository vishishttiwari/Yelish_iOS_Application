//
//  ImagesViewCell.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 15/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "ImagesViewCell.h"

@implementation ImagesViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.locationImages = [[UIImageView alloc] init];
        self.video = [[UIImageView alloc] init];
        self.locationImages.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.locationImages];
        [self.contentView addSubview:self.video];
    }
    return self;
}

-(void)prepareForReuse{
    self.locationImages.image = nil;
    [super prepareForReuse];
}

@end