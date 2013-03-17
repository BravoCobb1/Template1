//
//  Placemark.m
//  Template1
//
//  Created by Collier, Jeff on 3/2/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "GeoLocation.h"

@interface GeoLocation ()

// MKAnnotation Protocol
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

@implementation GeoLocation

// MKAnnotation Protocol

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return nil;
    /*NSString *areaOfInterest = (NSString *)self.areasOfInterest[0];
    NSArray *addressLines = (NSArray *)[self.addressDictionary objectForKey:@"FormattedAddressLines"];
    NSString *addressLine1 = (NSString *)addressLines[0];
    if (self.name != nil || areaOfInterest != nil)
        return addressLine1;
    else
        return nil;*/
}

- (MKPlacemark *)placemark
{
    if (_placemark != nil)
        return _placemark;
    
    if (self.location != nil)
        _placemark = [[MKPlacemark alloc] initWithCoordinate:self.location.coordinate addressDictionary:nil];

    return _placemark;
}

- (NSString *)addressString
{
    return ABCreateStringWithAddressDictionary(self.placemark.addressDictionary, NO);
}

+ (GeoLocation *)geoFromName:(NSString *)name latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    GeoLocation *geoLocation = [[GeoLocation alloc] init];
    geoLocation.name = name;
    geoLocation.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    return geoLocation;
}

+ (GeoLocation *)geoFromPlacemark:(MKPlacemark *)placemark
{
    GeoLocation *geoLocation = [[GeoLocation alloc] init];
    
    if (placemark == nil)
        return geoLocation;
    
    NSString *areaOfInterest = (NSString *)placemark.areasOfInterest[0];
    NSArray *addressLines = (NSArray *)[placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
    NSString *addressLine1 = (NSString *)addressLines[0];
    if (placemark.name != nil)
        geoLocation.name = placemark.name;
    else if (areaOfInterest != nil)
        geoLocation.name =  areaOfInterest;
    else if (addressLine1 != nil)
        geoLocation.name =  addressLine1;
    
    geoLocation.placemark = placemark;
    geoLocation.location = placemark.location;
    
    return geoLocation;
}

@end
