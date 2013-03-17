//
//  Entity1Type.h
//  Template1
//
//  Created by Collier, Jeff on 2/16/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity1Type : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id thumbnailImage;

@end
