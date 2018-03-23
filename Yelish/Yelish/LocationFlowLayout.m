//
//  LocationFlowLayout.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 10/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "LocationFlowLayout.h"

@implementation LocationFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.minimumLineSpacing = 2.0;
        self.minimumInteritemSpacing = 2.0;
        self.sectionInset = UIEdgeInsetsMake(2.0, 0.0, 2.0, 0.0);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (CGSize)itemSize
{
    NSInteger numberOfColumns = 1;
    
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - (numberOfColumns - 1)) / numberOfColumns;
    return CGSizeMake(itemWidth, (itemWidth * 500/750));
}


@end
