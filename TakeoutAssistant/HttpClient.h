//
//  HttpClient.h
//  TakeoutAssistant
//
//  Created by Jike on 7/31/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpClient.h"

@interface HttpClient : NSObject
+(void) searchByPhone:(NSString*) num;
@end
