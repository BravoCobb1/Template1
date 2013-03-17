//
//  GeoPickerDetailViewController.m
//  Template1
//
//  Created by Collier, Jeff on 3/2/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "GeoPickerDetailViewController.h"

@interface GeoPickerDetailViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)openInMaps:(id)sender;

@end

@implementation GeoPickerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    [self.mapView setScrollEnabled:YES];
    
    // add a pin using self as the object implementing the MKAnnotation protocol
    [self.mapView addAnnotation:self.geoLocation];
    
    // TODO: Consider this alternative
    /*MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
    pa.coordinate = placemark.location.coordinate;
    pa.title = ABCreateStringWithAddressDictionary(placemark.addressDictionary, YES);*/
    
    /*MKCoordinateRegion region =  MKCoordinateRegionMakeWithDistance(self.placemark.location.coordinate, 200, 200);
    [self.mapView setRegion:region animated:YES];*/
    // TODO: Consider this alternative
    // Set your region using placemark (not point)
    /*MKCoordinateRegion region = self.mapView.region;
    region.center = placemark.region.center;
    region.span.longitudeDelta /= 8.0;
    region.span.latitudeDelta /= 8.0;*/

    // Select the PointAnnotation programatically
    [self.mapView selectAnnotation:self.geoLocation animated:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)openInMaps:(id)sender
{
    // TODO: Pop-up for actions, and to clarify Send to Maps

    // For >= iOS 6.0, MKMapItem is the preferred method for opening the Maps app
    
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:self.geoLocation.placemark];
        
        // Create a region centered on the starting point with a 10km span
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.geoLocation.coordinate, 10000, 10000);

        NSMutableDictionary *launchOptionsDictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
        [launchOptionsDictionary setObject:[NSNumber numberWithUnsignedInteger:MKMapTypeStandard] forKey:MKLaunchOptionsMapTypeKey];
        [launchOptionsDictionary setObject:[NSValue valueWithMKCoordinate:region.center] forKey:MKLaunchOptionsMapCenterKey];
        [launchOptionsDictionary setObject:[NSValue valueWithMKCoordinateSpan:region.span] forKey:MKLaunchOptionsMapSpanKey];
        [launchOptionsDictionary setObject:[NSNumber numberWithBool:0] forKey:MKLaunchOptionsShowsTrafficKey];
        [launchOptionsDictionary setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
        
        NSArray *mapItems = [NSArray arrayWithObjects:[MKMapItem mapItemForCurrentLocation], mapItem, nil];
        
        // Open the item in Maps, specifying the map region to display.
        [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptionsDictionary];
    }
    else
    {
        // For < iOS 6.0, open with a NSURL
        // TODO: Fix with parameters following https://developer.apple.com/library/ios/#featuredarticles/iPhoneURLScheme_Reference/Articles/MapLinks.html#//apple_ref/doc/uid/TP40007894-SW1
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.apple.com/?q"]];
    }
    
}
@end
