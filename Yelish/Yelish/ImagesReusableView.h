//
//  ImagesReusableView.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 15/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>

@interface ImagesReusableView : UICollectionReusableView

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
