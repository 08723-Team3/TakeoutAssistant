//
//  Restaurant.h
//  TakeoutAssistant
//
//  Created by Gang Wu on 7/30/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dish;

@interface Restaurant : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSSet *menu;
@end

@interface Restaurant (CoreDataGeneratedAccessors)

- (void)addMenuObject:(Dish *)value;
- (void)removeMenuObject:(Dish *)value;
- (void)addMenu:(NSSet *)values;
- (void)removeMenu:(NSSet *)values;

@end
