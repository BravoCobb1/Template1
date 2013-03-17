//
//  GeoPickerTableViewController.h
//  Template1
//
//  Created by Collier, Jeff on 2/20/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoLocation.h"

@class GeoPickerTableViewController;

@protocol GeoPickerTableViewControllerDelegate <NSObject>

- (void)geoPickerTableViewController:(GeoPickerTableViewController *)controller didSelectGeo:(GeoLocation *)geoLocation;

@end

@interface GeoPickerTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

// Populate with suggested placemarks that will not require searching
@property (nonatomic) NSMutableArray *pickerList;
@property (nonatomic) GeoLocation *geoLocation;

@property (nonatomic, weak) id <GeoPickerTableViewControllerDelegate> delegate;

@end
