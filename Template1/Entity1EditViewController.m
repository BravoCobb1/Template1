//
//  Entity0DetailViewController.m
//  Template1
//
//  Created by Collier, Jeff on 2/11/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "Entity1EditViewController.h"
#import "Entity1TypePickerViewController.h"
#import "GeoPickerTableViewController.h"
#import "GeoLocation.h"
#import "Data/Entity1.h"

@interface Entity1EditViewController ()


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateDetailLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *locationDetailLabel;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)dateChanged:(id)sender;
- (IBAction)textFieldBegin:(id)sender;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) NSUInteger mode;
#define MODE_ADD 1
#define MODE_EDIT 2

@end

@implementation Entity1EditViewController

#pragma mark - Draw

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Determine the mode
    if (self.entity1.name == nil)
        self.mode = MODE_ADD;
    else
        self.mode = MODE_EDIT;
    
    // TODO: Determine which "current locale" this uses [NSDateFormatter localizedStringFromDate:self.datePicker.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    // TODO: Convert to device current locale?
    [self.dateFormatter setLocale:(NSLocale *)[APP_DELEGATE.settings objectForKey:@"locale"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];

    self.typeLabel.text = NSLocalizedString(@"Entity1Type", nil);
    self.dateLabel.text = NSLocalizedString(@"Entity1Date", nil);

    [self configureView];
    
    // TODO: Default image based on the type
    
    // TODO: Default location and detail label for it to current.
    // TODO: Allow location name without address/long-latt
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidLayoutSubviews
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RMStadium-568"]];
}

// Utility Methods

- (void)configureView
{
    switch (self.mode)
    {
        case MODE_ADD:
            self.title = NSLocalizedString(@"Entity1AddTitle", nil);
            self.typeDetailLabel.text = @"";
            self.dateDetailLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
            [self.nameTextField becomeFirstResponder];
            break;
            
        case MODE_EDIT:
            self.title = self.entity1.name;
            self.nameTextField.text = self.entity1.name;
            self.typeDetailLabel.text = self.entity1.type.name;
            self.dateDetailLabel.text = [self.dateFormatter stringFromDate:self.entity1.date1];
            self.imageView.image = self.entity1.thumbnailImage;
            break;
    }

}

// UITableViewDelegate Protocol

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            //sectionName = NSLocalizedString(@"Entity1Name", nil);
            break;
    }
    return sectionName;
}

#pragma mark - Editing

// UITextFieldDelegate Protocol

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{    
    if (textField == self.nameTextField)
        self.title = self.entity1.name;
    return YES;
}

// UITableViewDelegate Protocol

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If a text field had been selected, then a keyboard should be visible. Dismiss
    if (indexPath.section == 0)
    {
        [self.nameTextField resignFirstResponder];
    }
    // If a date picker had been selected, then dismiss the picker
    else if (indexPath.section == 2)
    {
        CGRect pickerFrame = self.datePicker.frame;
        pickerFrame.origin.y = self.view.frame.size.height;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.40];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
        self.datePicker.frame = pickerFrame;
        [UIView commitAnimations];
    }
 
}

// UITableViewDelegate Protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Open text field even if user taps in the whitespace outisde the text field but inside the section
    if (indexPath.section == 0)
    {
        [self.nameTextField becomeFirstResponder];
    }
    // If a date picker has been selected, then display the picker
    else if (indexPath.section == 2)
    {
        // the date picker might already be showing, so don't add it to our view
        if (self.datePicker.superview == nil)
        {
            CGRect startFrame = self.datePicker.frame;
            CGRect endFrame = self.datePicker.frame;
            
            // the start position is below the bottom of the visible frame
            startFrame.origin.y = self.view.frame.size.height;
            
            // the end position is slid up by the height of the view
            endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
            
            self.datePicker.frame = startFrame;
            
            // Add to the parent view of the table so that the table can be scrolled without also scrolling the picker
            [self.view.superview addSubview:self.datePicker];
            
            // Scroll up the table view if the date picker will overlap the table row
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGFloat overlap = endFrame.origin.y - cell.frame.origin.y;
            if (overlap > 0)
            {
                [tableView setContentOffset:CGPointMake(0, overlap) animated:YES];
            }
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.40];
            self.datePicker.frame = endFrame;
            [UIView commitAnimations];
        }
    }
    // If the image has been selected, then display the image picker
    else if (indexPath.section == 3)
    {
        [self takePic];
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)dateChanged:(id)sender
{
    /* If multiple dates, determine which one to change
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.pickerView.date]; */
    
    self.dateDetailLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
}

- (IBAction)textFieldBegin:(id)sender
{
    // TODO: Learn how to fix this correctly. When I tap INSIDE the text field, it is not delegating didDeselect: As a result, the date picker is not beign dismissed (if current selected row). Also it is not delegating didSelect: to the row with the text field. Can willSelectRowAtIndexPath: help?
    if (self.datePicker.superview != nil)
    {
        CGRect pickerFrame = self.datePicker.frame;
        pickerFrame.origin.y = self.view.frame.size.height;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.40];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
        self.datePicker.frame = pickerFrame;
        [UIView commitAnimations];
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
}

- (void)takePic
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        return;
    
    // UIImagePickerController let's the user choose an image.
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    //imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
    // UIImagePickerControllerSourceTypePhotoLibrary];

    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;

    // TODO: Add code from PrintPhoto sample project with popovercontroller for iPad
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it from the view hierarchy
	[self.datePicker removeFromSuperview];
}


/*
 tableView:accessoryButtonTappedForRowWithIndexPath:
*/

#pragma mark - Pick Type and Geo

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PickType"])
	{
		Entity1TypePickerViewController *pickerController = segue.destinationViewController;
        pickerController.managedObjectContext = self.entity1.managedObjectContext;
        pickerController.entity1Type = self.entity1.type;
		pickerController.delegate = self;
		//pickerController.type = self.typeDetailLabel.text;
	}
	else if ([segue.identifier isEqualToString:@"PickGeo"])
	{
		GeoPickerTableViewController *geoPickerController = segue.destinationViewController;
        //geoPickerController.geoLocation = self.geoLocation;
		geoPickerController.delegate = self;
	}
}

#pragma mark - Picked Type

// Entity1TypePickerViewControllerDelegate Protocol

- (void)entity1TypePickerViewController:(Entity1TypePickerViewController *)controller didSelectType:(Entity1Type *)entity1Type
{
    self.entity1.type = entity1Type;
    self.typeDetailLabel.text = entity1Type.name;
    
    // TODO: Should I also deselect the cell with animation as the Apple Table View Programming Guide for iOS says under Managing Selections?
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Picked Geo

// GeoPickerTableViewControllerDelegate Protocol
- (void)geoPickerTableViewController:(GeoPickerTableViewController *)controller didSelectGeo:(GeoLocation *)geoLocation
{
    // TODO: Switch to this self.geoLocation = geoLocation;
    self.locationDetailLabel.text = geoLocation.title;
    
    // TODO: Should I also deselect the cell with animation as the Apple Table View Programming Guide for iOS says under Managing Selections?
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Camera

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // Handle if not a still image capture: if (CFStringCompare ((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)

    UIImage *editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *imageToSave;
    if (editedImage)
        imageToSave = editedImage;
    else
        imageToSave = originalImage;
    
	NSManagedObjectContext *context = self.entity1.managedObjectContext;

    // If the event already has a photo, delete it.
	if (self.entity1.image1)
		[context deleteObject:self.entity1.image1];

    // Create a new photo object and set the image.
	Image1 *image1 = [NSEntityDescription insertNewObjectForEntityForName:@"Image1" inManagedObjectContext:context];
	image1.image = imageToSave;

    // Associate the photo object with the event.
	self.entity1.image1 = image1;
	
	// Create a thumbnail version of the image for the event object.
	CGSize size = imageToSave.size;
	CGFloat ratio = 0;
	if (size.width > size.height)
		ratio = 44.0 / size.width;
	else
		ratio = 44.0 / size.height;
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[imageToSave drawInRect:rect];
	self.entity1.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    // Update the image in the edit view with the thumbnail
    self.imageView.image = self.entity1.thumbnailImage;
    // TODO: Without this, the thumbnail is skewed. Why?
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Save

// Done button

- (IBAction)done:(id)sender
{
    self.entity1.name = self.nameTextField.text;
    self.entity1.date1 = self.datePicker.date;
    self.entity1.timeStamp = [NSDate date];
    // TODO: Move image model sets here, or disperse these
    
    // Commit the changes to entity1, image1
	NSError *error = nil;
	if (![self.entity1.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}

    [self.delegate entity1EditViewController:self didSave:self.entity1];
}

#pragma mark - Cancel

// Cancel button

- (IBAction)cancel:(id)sender {
    
    // Rollback the changes to entity1, image1
    if (self.mode == MODE_ADD)
    {
        [self.entity1.managedObjectContext deleteObject:self.entity1];
        if (self.entity1.image1)
            [self.entity1.managedObjectContext deleteObject:self.entity1.image1];
    }
    else
    {
        // TODO: What is the right way to rollback edits without impacting other changes in the transaction?
        [self.entity1.managedObjectContext rollback];
    }
    
	NSError *error = nil;
	if (![self.entity1.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}

    [self.delegate entity1EditViewControllerDidCancel:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
