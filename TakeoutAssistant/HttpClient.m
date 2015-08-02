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
    NSLog(raw.description);
    
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
//                                                     inDomains:NSUserDomainMask] firstObject];
//    
//    
//    NSString *documentName = @"TakeoutDatabase";
//    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
//    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
//    
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
//    if(fileExists){
//        [document openWithCompletionHandler:^(BOOL success) {
//            /* block to execute when open */
//            if (success) [self documentIsReady];
//            if (!success) NSLog(@"couldn’t open document at %@", url);
//        }];
//    } else {
//        [document saveToURL:url
//           forSaveOperation:UIDocumentSaveForCreating
//          completionHandler:^(BOOL success) {
//              /* block to execute when create is done */
//              if (success) [self documentIsReady];
//              if (!success) NSLog(@"couldn’t create document at %@", url);
//          }];
//    }
    
    

    
    
    return raw;
    
//    NSArray* arr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
//    NSDictionary *b = arr[0];
//    NSLog(b.description);
}

@end
