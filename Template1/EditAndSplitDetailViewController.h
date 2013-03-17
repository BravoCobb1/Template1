//
//  DetailViewController.h
//  Template1
//
//  Created by Collier, Jeff on 2/10/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data/Entity1.h"

@interface EditAndSplitDetailViewController : UIViewController <UISplitViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) Entity1 *entity1;

@end
