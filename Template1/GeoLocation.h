//
//  Placemark.h
//  Template1
//
//  Created by Collier, Jeff on 3/2/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CLPlacemark.h>

@interface GeoLocation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *name;
@property (nonatomic) CLLocation *location;
@property (nonatomic) MKPlacemark *placemark;

// MKAnnotation Protocol
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (NSString *)addressString;

+ (GeoLocation *)geoFromName:(NSString *)name latitude:(double)latitude longitude:(double)longitude;
+ (GeoLocation *)geoFromPlacemark:(CLPlacemark *)placemark;

@end
