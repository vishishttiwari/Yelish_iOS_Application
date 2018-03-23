//
//  GradientView2.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 24/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "GradientView2.h"

@implementation GradientView2

// Change the views layer class to CAGradientLayer class
+ (Class)layerClass
{
    return [CAGradientLayer class];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initGradientLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initGradientLayer];
    }
    return self;
}

// Make custom configuration of your gradient here
- (void)initGradientLayer {
    CAGradientLayer *gLayer = (CAGradientLayer *)self.layer;
    
    NSNumber *one = [NSNumber numberWithFloat:0.0];
    NSNumber *two = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:one, two, nil];
    
    gLayer.locations = locations;
    
    gLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
}

@end