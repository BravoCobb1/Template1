//
//  Entity1DetailViewController.h
//  Template1
//
//  Created by Collier, Jeff on 2/28/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data/Entity1.h"
#import "Entity1EditViewController.h"

@interface Entity1DetailViewController : UITableViewController <Entity1EditViewControllerDelegate>

@property (strong, nonatomic) Entity1 *entity1;

@end
