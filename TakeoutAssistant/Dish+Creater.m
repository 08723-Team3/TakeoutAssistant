//
//  Dish+Creater.m
//  TakeoutAssistant
//
//  Created by Gang Wu on 7/30/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import "Dish+Creater.h"

@implementation Dish (Creater)
+(Dish *)createWithContext:(NSManagedObjectContext *)managedObjectContext{
    Dish *dish = [NSEntityDescription insertNewObjectForEntityForName:@"Dish"
                                               inManagedObjectContext:managedObjectContext];
    return dish;
}
@end
