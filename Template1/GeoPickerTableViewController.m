//
//  GeoPickerTableViewController.m
//  Template1
//
//  Created by Collier, Jeff on 2/20/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "GeoPickerTableViewController.h"
#import "GeoPickerDetailViewController.h"
#import "GeoLocation.h"
// TODO: Merge Placemark.h with GeoPicker? 

@interface GeoPickerTableViewController ()

@property (nonatomic) CLGeocoder *geocoder;
@property (nonatomic) MKPlacemark *tempPlacemark;

// Search
@property (nonatomic) NSArray *searchList;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic, copy) NSString *savedSearchText;

@end

// TODO: Look at the customzing the UI in UISearchBar reference and also the searchbarcontroller enhancement

@implementation GeoPickerTableViewController

#pragma mark - Draw

- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO: Replace with Core Data
    self.pickerList = [NSMutableArray arrayWithObjects:
                       [GeoLocation geoFromName:@"Madison Square Garden" latitude:40.750312 longitude:-73.992979],
                       [GeoLocation geoFromName:@"Augusta National Golf Club" latitude:33.501523 longitude:-82.021725],
                       [GeoLocation geoFromName:@"HP Pavillion at San Jose" latitude:37.333647 longitude:-121.902605], nil];
   
    /*self.pickerList = [NSMutableArray arrayWithObjects:@"Home", @"Office", @"Hotel", nil];*/

	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchText)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setText:self.savedSearchText];
        self.savedSearchText = nil;
    }
    
    /* TODO:
     NSArray *recents = [[NSUserDefaults standardUserDefaults] objectForKey:RecentSearchesKey];
    if (recents) {
        self.suggestedSearches = recents;
        self.filteredRecentSearches = recents;
    }
    */
    
	self.searchList = [NSArray arrayWithArray:self.pickerList];
	
    self.geocoder = [[CLGeocoder alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// UITableViewDataSource Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Since this class is the delegate for the search controller, either can call this method
    return [[self listForTableView:tableView] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // As of iOS 6.0, dequeue method now guarantees returning a cell. Style set in viewDidLoad with tableView:registerClass:
    // Must use SELF.tableview because just tableview would refer to the search display controller's tableview, and that class is not registered with the cell reuse identifier
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GeoPickerCell" forIndexPath:indexPath];
    
    // Since this class is the delegate for the search controller, either can call this method
    [self configureCell:cell forTableView:tableView atIndexPath:indexPath];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// Utility Methods

- (void)configureCell:(UITableViewCell *)cell forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    GeoLocation *geoLocation = (GeoLocation *)[[self listForTableView:tableView] objectAtIndex:indexPath.row];
    cell.textLabel.text = geoLocation.title;
    cell.detailTextLabel.text = geoLocation.subtitle;
}

#pragma mark - Searching

// UISearchBarDelegate Protocol

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // Re-filter the search results with every change to the search text
    [self filterContentForSearchText:searchText];
}

// UISearchDisplayDelegate Protocol

// TODO: Add support for iPad and pop-up controller

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // TODO: Initiate asynchronous search, and reload table once results are received
    return YES;
}

// Utility Methods

- (void)filterContentForSearchText:(NSString*)searchText
{
    // Reset the filter and lazy instantiation will re-create on the table reload
    self.searchList = nil;
}

#pragma mark - Search

// UISearchBarDelegate Protocol

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // The desired content is not in the suggested list. Clear and search.
    self.searchList = nil;
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    // TODO: Lock UI and spin?
    // Search asynchronously for now
    // TODO: See Concurrency Programming Guide / Dispatch Queues and consider if it would be better to use a concurrent queue to avoid the main thread
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self search:searchBar.text];
    });
}

- (void)search:(NSString *)searchText
{
    // TODO: Replace with geocode
    
    [self.geocoder geocodeAddressString:searchText completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"geocodeAddressString:completionHandler: Completion Handler called!");
        if (error)
        {
            NSLog(@"Geocode failed with error: %@", error);
            //[self displayError:error];
            return;
        }
        
        NSLog(@"Received placemarks: %@", placemarks);
        NSMutableArray *foundGeoLocations = [[NSMutableArray alloc] initWithCapacity:[placemarks count]];
        for (CLPlacemark *p in placemarks)
        {
            NSLog(@"areasOfInterest: %@", p.areasOfInterest);
            NSLog(@"name: %@", p.name);
            NSLog(@"location: %@", p.location);
            NSLog(@"addressDictionary: %@", p.addressDictionary);
            NSLog(@"administrativeArea: %@", p.administrativeArea);
            NSLog(@"country: %@", p.country);
            NSLog(@"inlandWater: %@", p.inlandWater);
            NSLog(@"ISOcountryCode: %@", p.ISOcountryCode);
            NSLog(@"locality: %@", p.locality);
            NSLog(@"ocean: %@", p.ocean);
            NSLog(@"subAdministrativeArea: %@", p.subAdministrativeArea);
            NSLog(@"subLocality: %@", p.subLocality);
            NSLog(@"subThoroughfare: %@", p.subThoroughfare);
            NSLog(@"thoroughfare: %@", p.thoroughfare);
            
            [foundGeoLocations addObject:[GeoLocation geoFromPlacemark:p]];
            
            //[self.filteredPLStrings addObject:p.country];
            /*NSString *addressString = ABCreateStringWithAddressDictionary(p.addressDictionary, NO);
            if ([p.areasOfInterest count] > 0)
                [placemarkNames addObject:(NSString *)p.areasOfInterest[0]];
            else
                [placemarkNames addObject:addressString];*/
        }
        
        // If picker list < the search list, the cell reuse will be out of bounds. Add the results to keep larger
        [self.pickerList addObjectsFromArray:foundGeoLocations];
        [self.tableView reloadData];
        
        self.searchList = [NSArray arrayWithArray:foundGeoLocations];
        [self.searchDisplayController.searchResultsTableView reloadData];

        /*self.filteredSearchList = [NSArray arrayWithObject:@"Philips Arena"];*/
        /*[self.searchDisplayController.searchResultsTableView beginUpdates];
        [self.searchDisplayController.searchResultsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [self.searchDisplayController.searchResultsTableView endUpdates];*/
    }];
}

#pragma mark - Search Canceled

// UISearchDisplayDelegate Protocol

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
{
    self.searchList = nil;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
   return;
}

- (void)filterContentForSearchTextREVISE:(NSString*)searchText
{
    // TODO: See GeoCoder sample project for running the dispatch quueue differently
    
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	//[self.filteredSearchList removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    if ([searchText isEqualToString:@"46"]) {
        //[self.filteredPLStrings addObject:@"46 Search String"];
        [self.geocoder geocodeAddressString:@"Philips Arena, Atlanta" completionHandler:^(NSArray *placemarks, NSError *error) {
            // [self.geocoder geocodeAddressString:searchText completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"geocodeAddressString:completionHandler: Completion Handler called!");
            if (error)
            {
                NSLog(@"Geocode failed with error: %@", error);
                //[self displayError:error];
                // TODO: Notify user pleasantly for [error code] == kCLErrorGeocodeFoundNoResult:

                return;
            }
            
            NSLog(@"Received placemarks: %@", placemarks);
            for (CLPlacemark *p in placemarks)
            {
                NSLog(@"name: %@", p.name);
                NSLog(@"administrativeArea: %@", p.administrativeArea);
                NSLog(@"country: %@", p.country);
                NSLog(@"inlandWater: %@", p.inlandWater);
                NSLog(@"ISOcountryCode: %@", p.ISOcountryCode);
                NSLog(@"locality: %@", p.locality);
                NSLog(@"ocean: %@", p.ocean);
                NSLog(@"subAdministrativeArea: %@", p.subAdministrativeArea);
                NSLog(@"subLocality: %@", p.subLocality);
                NSLog(@"subThoroughfare: %@", p.subThoroughfare);
                NSLog(@"thoroughfare: %@", p.thoroughfare);
                //[self.filteredPLStrings addObject:p.country];
            }
            // TODO: See Concurrency Programming Guide / Dispatch Queues and consider if it would be better to use a concurrent queue to avoid the main thread
            dispatch_async(dispatch_get_main_queue(),^ {
                
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
            //self.placemarks = placemarks;
            
            //[self displayPlacemarks:placemarks];
        }];
        
    }
}

// UISearchBarDelegate

//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
  //  [self.searchStrings addObject:self.searchBar.text];
    /*NSInteger i = [self.searchStrings count] - 1;
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.searchStrings count] - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];*/
    //[self.tableView reloadData];


    /*[self.geocoder geocodeAddressString:self.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"geocodeAddressString:completionHandler: Completion Handler called!");
        if (error)
        {
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        
        NSLog(@"Received placemarks: %@", placemarks);
        self.placemarks = placemarks;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        
        //[self displayPlacemarks:placemarks];
    }];*/
//}

//- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
//{
  //  NSLog(@"searchBarResultsListButtonClicked");
//}

// display a given NSError in an UIAlertView
- (void)displayError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),^ {
        
        NSString *message;
        switch ([error code])
        {
            case kCLErrorGeocodeFoundNoResult:
                message = @"kCLErrorGeocodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled:
                message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult:
                message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default:
                message = [error description];
                break;
        }
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];;
        [alert show];
    });   
}

#pragma mark - Selected

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MapLocation"])
    {
        GeoPickerDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.geoLocation = (GeoLocation *)[self objectSelectedInTable];
    }
}

// UITableViewDelegate Protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Don't highlight the selected row in blue
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.geoLocation = [[self listForTableView:tableView] objectAtIndex:indexPath.row];
    
    if ([self.searchDisplayController isActive])
        [self.searchDisplayController setActive:NO animated:YES];
    
    [self.delegate geoPickerTableViewController:self didSelectGeo:self.geoLocation];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Model

- (NSArray *)searchList
{
    if (_searchList != nil)
        return _searchList;
    
    NSString *searchText = self.searchDisplayController.searchBar.text;
    if ([searchText length] == 0)
        _searchList = self.pickerList;
    else
    {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
        _searchList = [self.pickerList filteredArrayUsingPredicate:filterPredicate];
    }
    
    return _searchList;
}

// Utility Methods

- (NSArray *)listForTableView:(UITableView *)tableView
{
    return tableView == self.tableView ? self.pickerList : self.searchList;
}

- (UITableView *)tableViewForList:(NSArray *)array
{
    return array == self.searchList ? self.tableView : self.searchDisplayController.searchResultsTableView;
}

- (UITableView *)tableViewForSearchState
{
    return [self.searchDisplayController isActive] ? self.searchDisplayController.searchResultsTableView : self.tableView;
}

- (id)objectSelectedInTable
{
    // There are two different table views when a search bar is present
    UITableView *visibleTableView = [self tableViewForSearchState];
    NSIndexPath *selectedIndexPath = [visibleTableView indexPathForSelectedRow];
    
    // Return the object from the list corresponding to the visible table view. Since there is only one section, the table row == the array index
    return [[self listForTableView:visibleTableView] objectAtIndex:selectedIndexPath.row];
}

#pragma mark - Other

- (void)viewDidDisappear:(BOOL)animated
{
    // Save the search state so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchText = [self.searchDisplayController.searchBar text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
