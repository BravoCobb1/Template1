//
//  Entity1TableViewCell.m
//  Template1
//
//  Created by Collier, Jeff on 2/10/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import "Entity1TableViewCell.h"

@implementation Entity1TableViewCell

// Override in order to set the style. The new iOS 6.0 method to dequeue guarantees a cell, but hardcodes the default style
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
