//
//  Entity1DetailViewController.m
//  Template1
//
//  Created by Collier, Jeff on 2/28/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import "Entity1DetailViewController.h"
#import "Entity1EditViewController.h"
#import "RequestTableViewController.h"

@interface Entity1DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
- (IBAction)requestEntity1:(UIButton *)sender;

@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation Entity1DetailViewController

#pragma mark - Draw

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)configureView
{
    self.title = self.entity1.name;
    self.nameLabel.text = self.entity1.name;
    self.typeLabel.text = self.entity1.type.name;
    self.dateLabel.text = [self.dateFormatter stringFromDate:self.entity1.date1];
    self.thumbnailImageView.image = self.entity1.thumbnailImage;    
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

#pragma mark - Edit

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EditEntity1"])
    {
        // Handle the case with direct to detail controller and via a navigation controller
        id destinationController = [segue destinationViewController];
        if ([destinationController class] == [UINavigationController class])
            destinationController = [[destinationController viewControllers] objectAtIndex:0];
        Entity1EditViewController *editController =  (Entity1EditViewController *)destinationController;
        editController.entity1 = self.entity1;
        editController.delegate = self;
    }
    
    else if ([[segue identifier] isEqualToString:@"RequestEntity1"])
    {
        // Handle the case with direct to detail controller and via a navigation controller
        id destinationController = [segue destinationViewController];
        if ([destinationController class] == [UINavigationController class])
            destinationController = [[destinationController viewControllers] objectAtIndex:0];
        RequestTableViewController *requestController =  (RequestTableViewController *)destinationController;
        requestController.entity1 = self.entity1;
        // TODO: requestController.delegate = self;
    }
    
}

#pragma mark - Edited

- (void)entity1EditViewController:(Entity1EditViewController *)controller didSave:(Entity1 *)entity1
{
    // Reload the fields in case any were edited.
    [self configureView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Canceled

// Entity1EditViewControllerDelegate Protocol
- (void)entity1EditViewControllerDidCancel:(Entity1EditViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request

- (IBAction)requestEntity1:(UIButton *)sender
{
}

#pragma mark - Getters and Setters

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setLocale:(NSLocale *)[APP_DELEGATE.settings objectForKey:@"locale"]];
        [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return _dateFormatter;
}

@end

