//
//  Location1.h
//  Template1
//
//  Created by Collier, Jeff on 3/2/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CLPlacemark.h>
#import <MapKit/MapKit.h>

@class Entity1;

@interface Location1 : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * addressString;
@property (nonatomic, retain) Entity1 *entity1;

- (void)setFromPlacemark:(CLPlacemark *)placemark;

@end
