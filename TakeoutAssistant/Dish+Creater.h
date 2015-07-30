//
//  Dish+Creater.h
//  TakeoutAssistant
//
//  Created by Gang Wu on 7/30/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import "Dish.h"
#import <CoreData/CoreData.h>

@interface Dish (Creater)
+(Dish *)createWithContext:(NSManagedObjectContext *)managedObjectContext;
@end
