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
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:nil forKey:@"oauth_callback"];
    NSURLRequest *request = [TDOAuth URLRequestForPath:@"/authorize"
                                     GETParameters:dict2
                                            scheme:@"http"
                                              host:@"http://api.yelp.com/v2/phone_search?phone=+15555555555"
                                       consumerKey:consumerKey
                                    consumerSecret:consumerSecret
                                       accessToken:accessToken
                                           tokenSecret:tokenSecret];
    NSURLResponse *response = nil;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    

    NSArray *raw = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSLog(raw.description);
    
    
    
}

@end
