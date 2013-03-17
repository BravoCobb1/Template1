//
//  Entity1.h
//  Template1
//
//  Created by Collier, Jeff on 2/10/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity1Type.h"
#import "Image1.h"

@interface Entity1 : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSDate * date1;
@property (nonatomic, retain) NSDate * changedTimeStamp;
@property (nonatomic, retain) UIImage *thumbnailImage;

@property (nonatomic, retain) Entity1Type *type;
@property (nonatomic, retain) Image1 *image1;

@end
