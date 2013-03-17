//
//  MasterViewController.h
//  Template1
//
//  Created by Collier, Jeff on 2/10/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity1EditViewController.h"
#import "Entity1DetailViewController.h"

#import <CoreData/CoreData.h>

@interface Entity1MasterTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate,  Entity1EditViewControllerDelegate>

@property (strong, nonatomic) Entity1DetailViewController *detailViewController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
