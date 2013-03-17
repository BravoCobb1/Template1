//
//  DetailViewController.m
//  Template1
//
//  Created by Collier, Jeff on 2/10/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import "EditAndSplitDetailViewController.h"

@interface EditAndSplitDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@end

@implementation EditAndSplitDetailViewController

#pragma mark - Managing the detail item

- (void)setEntity1:(Entity1*)newEntity1
{
    if (_entity1 != newEntity1) {
        _entity1 = newEntity1;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
    
    [self configureView];
    
    [self setEditing:FALSE animated:TRUE];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.entity1) {
        //self.nameTextField.text = [[self.entity1 valueForKey:@"timeStamp"] description];
        self.navigationItem.title = self.entity1.name;
        self.nameTextField.text = [self.entity1 valueForKey:@"name"];
        
    }
}

#pragma mark - Editing - UIViewController Overrides

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {

    [super setEditing:editing animated:animated];
    
    self.nameTextField.enabled = editing;
    
	[self.navigationItem setHidesBackButton:editing animated:YES];
    
    /*
	 If editing is finished, save the managed object context.
	 */
	if (!editing) {
		NSManagedObjectContext *context = self.entity1.managedObjectContext;
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}    
}

#pragma mark - Editing - UITextFieldDelegate Protocol

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == self.nameTextField) {
        self.entity1.name = self.nameTextField.text;
        self.navigationItem.title = self.entity1.name;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
