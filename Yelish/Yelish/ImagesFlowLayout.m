//
//  ImagesFlowLayout.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 15/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "ImagesFlowLayout.h"

@implementation ImagesFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.minimumLineSpacing = 1.0;
        self.minimumInteritemSpacing = 1.0;
        self.sectionInset = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 250);
    }
    return self;
}

- (CGSize)itemSize
{
    NSInteger numberOfColumns = 3;
    
    CGFloat itemWidth = ((CGRectGetWidth(self.collectionView.frame) - (numberOfColumns - 1)) / numberOfColumns);
    return CGSizeMake(itemWidth, (itemWidth * 1334/750));
}

@end
