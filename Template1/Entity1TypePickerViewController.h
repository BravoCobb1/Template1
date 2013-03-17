//
//  Entity1TypePickerViewController.h
//  Template1
//
//  Created by Collier, Jeff on 2/13/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data/Entity1Type.h"

@class Entity1TypePickerViewController;

@protocol Entity1TypePickerViewControllerDelegate <NSObject>

- (void)entity1TypePickerViewController:(Entity1TypePickerViewController *)controller didSelectType:(Entity1Type *)entity1Type;

@end

@interface Entity1TypePickerViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSString *type;
@property (nonatomic) Entity1Type *entity1Type;
@property (nonatomic, weak) id <Entity1TypePickerViewControllerDelegate> delegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
