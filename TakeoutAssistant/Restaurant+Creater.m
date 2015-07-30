//
//  Restaurant+Creater.m
//  TakeoutAssistant
//
//  Created by Gang Wu on 7/30/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import "Restaurant+Creater.h"

@implementation Restaurant (Creater)

+(Restaurant *)createWithContext:(NSManagedObjectContext *)managedObjectContext{
    Restaurant *restaurant = [NSEntityDescription insertNewObjectForEntityForName:@"Restaurant"
                                                           inManagedObjectContext:managedObjectContext];
    return restaurant;
}

@end
