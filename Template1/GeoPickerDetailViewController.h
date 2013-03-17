//
//  GeoPickerDetailViewController.h
//  Template1
//
//  Created by Collier, Jeff on 3/2/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GeoLocation.h"

@interface GeoPickerDetailViewController : UIViewController <MKAnnotation>

@property GeoLocation *geoLocation;

@end
