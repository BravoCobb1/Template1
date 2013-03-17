//
//  AppDelegate.m
//  Template1
//
//  Created by Collier, Jeff on 2/10/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import "AppDelegate.h"

#import "Data/Location1.h"
#import "Entity1MasterTableViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self customizeAppearance];
    
    // Initialize global setttings
    // TODO: Convert to strongly typed values to avoid casting?
    // TODO: Move to topViewController to avoid sloppy dependency back to app deledgate
    self.settings = [NSMutableDictionary dictionaryWithCapacity:25];
    // TODO: Improve with [NSLocale currentLocale] for device and [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] for the app
    [self.settings setObject:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] forKey:@"locale"];
    [self insertDemoData];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
        UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
        Entity1MasterTableViewController *controller = (Entity1MasterTableViewController *)masterNavigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
    }
    else
    {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        Entity1MasterTableViewController *controller = (Entity1MasterTableViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Drawing

- (void)customizeAppearance
{
    // UINavigationBar - Create resizable images and set for *all*
    // TODO: Add the 32 pixel nav bar height for rotation to landscape
    
    UIImage *gradientImage44 = [[UIImage imageNamed:@"NavBar-44"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Arial-Bold" size:0.0],
      UITextAttributeFont,
      nil]];

    // UINavigationBar Shadow - Shown only if background image
    // [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"NavBarShadow-15"]];
    
    // UISearchBar
    // TODO: Update with correct pixel images
    
    [[UISearchBar appearance] setBackgroundImage:gradientImage44];

    // UIToolbar
    // TODO: Updatew with correct pixel images and top and bottom
    
    [[UIToolbar appearance] setBackgroundImage:gradientImage44 forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // UIBarButtonItem - Create resizable images and set for *all*
    
    UIImage *button30 = [[UIImage imageNamed:@"NavBarButton-30"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
    // UIBarButtonItem Back - Create resizable images and set for *all*
    
    UIImage *buttonBack30 = [[UIImage imageNamed:@"NavBarBackButton-30"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack30
                                                      forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // TODO: http://www.raywenderlich.com/21703/user-interface-customization-in-ios-6
    
}

#pragma mark - Data Management

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

// TODO: Move the demo data to files
- (void) insertDemoData
{
    NSManagedObjectContext *context = self.managedObjectContext;

    // Entity1Type
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity1Type" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
	NSError *error = nil;
    NSUInteger rowCount = [context countForFetchRequest:fetchRequest error:&error];
	if (rowCount == NSNotFound) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    // If the Entity1Type table is empty, populate it;
    if (rowCount == 0) {
        Entity1Type *entity1Type = [NSEntityDescription insertNewObjectForEntityForName:@"Entity1Type" inManagedObjectContext:context];
        entity1Type.name = @"Celebrity Meet";
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        entity1Type = [NSEntityDescription insertNewObjectForEntityForName:@"Entity1Type" inManagedObjectContext:context];
        entity1Type.name = @"Concert";
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        entity1Type = [NSEntityDescription insertNewObjectForEntityForName:@"Entity1Type" inManagedObjectContext:context];
        entity1Type.name = @"Speaker";
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        entity1Type = [NSEntityDescription insertNewObjectForEntityForName:@"Entity1Type" inManagedObjectContext:context];
        entity1Type.name = @"Sporting Event";
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    // Location1
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Location1" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
	error = nil;
    rowCount = [context countForFetchRequest:fetchRequest error:&error];
	if (rowCount == NSNotFound) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    // If the Location1 table is empty, populate it;
    if (rowCount == 0) {
        Location1 *location1 = [NSEntityDescription insertNewObjectForEntityForName:@"Location1" inManagedObjectContext:context];
        location1.name = @"Madison Square Garden";
        location1.latitude = [NSNumber numberWithDouble:40.750312];
        location1.longitude = [NSNumber numberWithDouble:-73.992979];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        location1 = [NSEntityDescription insertNewObjectForEntityForName:@"Location1" inManagedObjectContext:context];
        location1.name = @"Augusta National Golf Club";
        location1.latitude = [NSNumber numberWithDouble:33.501523];
        location1.longitude = [NSNumber numberWithDouble:-82.021725];
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        location1 = [NSEntityDescription insertNewObjectForEntityForName:@"Location1" inManagedObjectContext:context];
        location1.name = @"HP Pavillion at San Jose";
        location1.latitude = [NSNumber numberWithDouble:37.333647];
        location1.longitude = [NSNumber numberWithDouble:-121.902605];
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Template1" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Template1.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
