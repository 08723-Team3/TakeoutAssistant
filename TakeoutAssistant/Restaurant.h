//
//  Restaurant.h
//  TakeoutAssistant
//
//  Created by Jike on 8/1/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dish;

@interface Restaurant : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * review;
@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *menu;
@end

@interface Restaurant (CoreDataGeneratedAccessors)

- (void)addMenuObject:(Dish *)value;
- (void)removeMenuObject:(Dish *)value;
- (void)addMenu:(NSSet *)values;
- (void)removeMenu:(NSSet *)values;

@end
