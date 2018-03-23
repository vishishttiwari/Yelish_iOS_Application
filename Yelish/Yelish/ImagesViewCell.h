//
//  ImagesViewCell.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 15/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UIImageView *locationImages;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (strong, nonatomic) IBOutlet UIImageView *video;

@end
