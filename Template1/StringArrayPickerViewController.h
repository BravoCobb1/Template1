//
//  StringArrayPickerViewController.h
//  Template1
//
//  Created by Collier, Jeff on 2/20/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringArrayPickerViewController;

@protocol StringArrayPickerViewControllerDelegate <NSObject>

- (void)stringArrayPickerViewController:(StringArrayPickerViewController *)controller didSelectString:(NSString *)string;

@end

@interface StringArrayPickerViewController : UITableViewController

@property (nonatomic) NSArray *strings;
@property (nonatomic) NSString *pickedString;
@property (nonatomic, weak) id <StringArrayPickerViewControllerDelegate> delegate;

@end
