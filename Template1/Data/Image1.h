//
//  Image1.h
//  Template1
//
//  Created by Collier, Jeff on 2/20/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entity1;

@interface Image1 : NSManagedObject

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) Entity1 *entity1;

@end
