//
//  HttpClient.m
//  TakeoutAssistant
//
//  Created by Jike on 7/31/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient

+(NSDictionary*) searchByPhone:(NSString*) num{
    YPAPISample *yp = [[YPAPISample alloc] init];
    NSURLRequest *request = [yp _searchRequestWithTerm:num location:@"US"];
    
    
    NSError *error;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    NSArray* arr = [json objectForKey:@"businesses"];
    if ([arr count] == 0) return nil;
    NSDictionary *raw = arr[0];

    return raw;
}

@end
