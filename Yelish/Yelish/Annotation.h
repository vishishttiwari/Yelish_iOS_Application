//
//  Annotation.h
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 10/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>

@interface Annotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
