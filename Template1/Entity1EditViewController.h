//
//  Entity0DetailViewController.h
//  Template1
//
//  Created by Collier, Jeff on 2/11/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity1TypePickerViewController.h"
#import "GeoPickerTableViewController.h"
#import "Data/Entity1.h"

@class Entity1EditViewController;

@protocol Entity1EditViewControllerDelegate <NSObject>

- (void)entity1EditViewControllerDidCancel:(Entity1EditViewController *)controller;
- (void)entity1EditViewController:(Entity1EditViewController *)controller didSave:(Entity1 *)entity1;

@end


@interface Entity1EditViewController : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Entity1TypePickerViewControllerDelegate, GeoPickerTableViewControllerDelegate>

@property (strong, nonatomic) Entity1 *entity1;
@property (nonatomic, weak) id <Entity1EditViewControllerDelegate> delegate;

@end
