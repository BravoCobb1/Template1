//
//  MasterViewController.m
//  Template1
//
//  Created by Collier, Jeff on 2/10/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import "Entity1MasterTableViewController.h"
#import "Entity1EditViewController.h"
#import "Entity1DetailViewController.h"
#import "Entity1TableViewCell.h"
#import "Data/Entity1.h"

@interface Entity1MasterTableViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

// Search
@property (strong, nonatomic) NSFetchedResultsController *searchFetchedResultsController;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic, copy) NSString *savedSearchText;

@end

@implementation Entity1MasterTableViewController

#pragma mark - Draw

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    // TODO: Convert to device current locale?
    [self.dateFormatter setLocale:(NSLocale *)[APP_DELEGATE.settings objectForKey:@"locale"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];

	// Setup the Navigation Bar
    
    // Title
    //self.title = NSLocalizedString(@"Entity1MasterTableTitle", nil);
    UIImage *titleLogoImage = [UIImage imageNamed:@"NavBarLogoTitle-40"];
    UIImageView *titleLogoView = [[UIImageView alloc] initWithImage:titleLogoImage];
    [self.navigationItem setTitleView:titleLogoView];
    
    // Buttons
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    /*UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
    self.detailViewController = (Entity1DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    // Setup the Search Bar
    
    // Start with the search bar hidden, until someone drags it down
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    
    // Restore Search State
    if (self.savedSearchText)
    {
        [self.searchDisplayController setActive:self.searchWasActive];
        self.searchDisplayController.searchBar.text = self.savedSearchText;
        self.savedSearchText = nil;
    }

    // See tableView:cellForRowAtIndexPath:
    //[self.tableView registerClass:[Entity1TableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidLayoutSubviews
{
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RMStadium-568"]];
}

// UITableViewDataSource Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsControllerForTableView:tableView] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsControllerForTableView:tableView] sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // As of iOS 6.0, dequeue method now guarantees returning a cell. Style set in viewDidLoad with tableView:registerClass:
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Entity1Cell" forIndexPath:indexPath];
    [self configureCell:cell forTableView:tableView atIndexPath:indexPath];
    return cell;
}

// Utility Methods

- (void)configureCell:(UITableViewCell *)cell forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    Entity1 *entity1 = (Entity1 *)[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    cell.textLabel.text = entity1.name;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:entity1.date1];
    cell.imageView.image = entity1.thumbnailImage;
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
    return YES;
}

// Utility Methods

- (void)filterContentForSearchText:(NSString*)searchText
{
    // Reset the filter and lazy instantiation will re-create on the table reload    
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
}

#pragma mark - Search

// UISearchBarDelegate Protocol

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // No need to do anything more since the text change has already filtered
}

#pragma mark - Search Canceled

// UISearchDisplayDelegate Protocol

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
{
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
}

#pragma mark - Selected

// UITableViewDelegate Protocol and Segue

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* TODO: Add back for iPad, which will require updates to the detail view controller */
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        Entity1 *entity1 = (Entity1 *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.entity1 = entity1;
    }
}

#pragma mark - Add and Detail

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddEntity1"])
    {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        Entity1 *entity1 = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        Entity1EditViewController *detailViewController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        detailViewController.entity1 = entity1;
        detailViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"DetailEntity1"])
    {
        Entity1 *entity1 = (Entity1 *)[self objectSelectedInTable];
        Entity1DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.entity1 = entity1;
    }
}


#pragma mark - Added

- (void)entity1EditViewController:(Entity1EditViewController *)controller didSave:(Entity1 *)entity1 {
    
    // The row will already be in the table, but the new field values in the cell will not displayed yet
    [self.tableView reloadData];
    // TODO: Can the addition be animated such as this for an array data source
    // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.players count] - 1 inSection:0];
    // [self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Add Canceled

// Entity1EditViewControllerDelegate Protocol

- (void)entity1EditViewControllerDidCancel:(Entity1EditViewController *)controller
{
    // TODO: Answer -> How does it know which controller? Top of the stack?
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - NSFetchedResultsControllerDelegate Protocol

- (NSFetchedResultsController *)searchFetchedResultsController
{
    if (_searchFetchedResultsController != nil)
        return _searchFetchedResultsController;

    _searchFetchedResultsController = [self newFetchedResultsControllerWithSearch:self.searchDisplayController.searchBar.text];
    return _searchFetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
        return _fetchedResultsController;

    _fetchedResultsController = [self newFetchedResultsControllerWithSearch:nil];
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)newFetchedResultsControllerWithSearch:(NSString *)searchString
{
    // Fetch Request and Batch Size
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity1" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    // Sort
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date1" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Filter
    
    if(searchString)
    {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchString];
        NSMutableArray *predicateArray = [NSMutableArray arrayWithObjects:namePredicate, nil];
        [fetchRequest setPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:predicateArray]];
        // TODO: Add other fields into an OR
    }

    // Execute
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:searchString ? nil : @"Entity1Master"];
    aFetchedResultsController.delegate = self;

    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return aFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = [self tableViewForFetchedResultsController:controller];
    [tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = [self tableViewForFetchedResultsController:controller];

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = [self tableViewForFetchedResultsController:controller];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] forTableView:tableView atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = [self tableViewForFetchedResultsController:controller];
    [tableView endUpdates];
}

// Utility Methods

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
    return tableView == self.tableView ? self.fetchedResultsController : self.searchFetchedResultsController;
}

- (UITableView *)tableViewForFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    return fetchedResultsController == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
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
    
    // Return the object from the fetched results controller corresponding to the visible table view
    return [[self fetchedResultsControllerForTableView:visibleTableView] objectAtIndexPath:selectedIndexPath];
}



/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

#pragma mark - Other

- (void)viewDidDisappear:(BOOL)animated
{
    // Save the Search State
    
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchText = [self.searchDisplayController.searchBar text];
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    // Save the Search State
    
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchText = [self.searchDisplayController.searchBar text];
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
    
    [super didReceiveMemoryWarning];

}


@end
