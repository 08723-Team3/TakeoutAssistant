//
//  HttpClient.h
//  TakeoutAssistant
//
//  Created by Jike on 7/31/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPAPISample.h"
#import "Restaurant.h"

@interface HttpClient : NSObject
+(NSDictionary*) searchByPhone:(NSString*) num;
@end
