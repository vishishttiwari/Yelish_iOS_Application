//
//  MeViewCell.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 21/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "MeViewCell.h"

@implementation MeViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.images = [[UIImageView alloc] init];
        self.video = [[UIImageView alloc] init];
        [self.contentView addSubview:self.images];
        [self.contentView addSubview:self.video];

    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.images.image = nil;
}
@end
