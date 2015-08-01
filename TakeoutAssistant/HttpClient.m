//
//  HttpClient.m
//  TakeoutAssistant
//
//  Created by Jike on 7/31/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import "HttpClient.h"


@implementation HttpClient

+(void) searchByPhone:(NSString*) num{
    NSString *consumerKey = @"4mCltr6EkIFMMKXSmI9ZAA";
    NSString *consumerSecret = @"uGn5WulOb_I5Pr240iIAHhcwBBw";
    NSString *accessToken = @"Bkk5g_dMo18B5e0kepfC7rqdtQC1Vmtw";
    NSString *tokenSecret= @"UkG5Ep-JEQwTm958KPD2-oP6HqM";
    
    
    
    YelpClient *client= [[YelpClient alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret accessToken:accessToken accessSecret:tokenSecret];
    
    
    [client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
    
}

@end
