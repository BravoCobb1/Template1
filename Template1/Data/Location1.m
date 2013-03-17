//
//  Location1.m
//  Template1
//
//  Created by Collier, Jeff on 3/2/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Location1.h"
#import "Entity1.h"


@implementation Location1

@dynamic name;
@dynamic latitude;
@dynamic longitude;
@dynamic addressString;
@dynamic entity1;

- (void)setFromPlacemark:(CLPlacemark *)placemark
{
    NSString *areaOfInterest = (NSString *)placemark.areasOfInterest[0];
    NSArray *addressLines = (NSArray *)[placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
    NSString *addressLine1 = (NSString *)addressLines[0];
    if (placemark.name != nil)
        self.name = placemark.name;
    else if (areaOfInterest != nil)
        self.name =  areaOfInterest;
    else if (addressLine1 != nil)
        self.name =  addressLine1;

    self.latitude = [NSNumber numberWithDouble:placemark.location.coordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:placemark.location.coordinate.longitude];
}

@end
