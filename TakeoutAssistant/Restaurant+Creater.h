//
//  Restaurant+Creater.h
//  TakeoutAssistant
//
//  Created by Gang Wu on 7/30/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import "Restaurant.h"
#import <CoreData/CoreData.h>

@interface Restaurant (Creater)
+(Restaurant *)createWithContext:(NSManagedObjectContext *)managedObjectContext;
@end
