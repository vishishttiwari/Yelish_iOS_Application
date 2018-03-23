//
//  MeViewCell.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 21/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *images;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (strong, nonatomic) IBOutlet UIImageView *video;

@end
