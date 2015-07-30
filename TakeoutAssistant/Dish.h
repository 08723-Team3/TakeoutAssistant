//
//  Dish.h
//  TakeoutAssistant
//
//  Created by Gang Wu on 7/30/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant;

@interface Dish : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) Restaurant *servedIn;

@end
