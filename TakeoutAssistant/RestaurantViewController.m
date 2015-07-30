//
//  RestaurantViewController.m
//  TakeoutAssistant
//
//  Created by Gang Wu on 7/30/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import "RestaurantViewController.h"
#import <CoreData/CoreData.h>
#import "Restaurant+Creater.h"
#import "Dish+Creater.h"

@interface RestaurantViewController ()
@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSArray *restaurants; // of Restaurant
@end

@implementation RestaurantViewController

- (IBAction)add:(UIBarButtonItem *)sender {
    // create a new restaurant
    Restaurant *restaurant = [Restaurant createWithContext:self.document.managedObjectContext];

    restaurant.name = [NSString stringWithFormat:@"Little Asia_%c", 65 + arc4random() % 26];
    restaurant.address = @"abcdefg";
    restaurant.phone = @"123456";
    
    // add a dish
    Dish *dish1 = [Dish createWithContext:self.document.managedObjectContext];
    dish1.name = @"Beef";
    dish1.price = @"12.5";
    [restaurant addMenuObject:dish1];
    
    // IMPORTANT!! update the database
    [self synchronize];
}

#pragma mark - Properties

-(UIManagedDocument *)document{
    if(!_document) _document = [self createDocument];
    return _document;
}

-(NSArray *)restaurants{
    if(!_restaurants) return @[];
    return _restaurants;
}

#pragma mark - Core Data

-(UIManagedDocument *)createDocument{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"TakeoutDatabase";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if(fileExists){
        [document openWithCompletionHandler:^(BOOL success) {
            /* block to execute when open */
            if (success) [self documentIsReady];
            if (!success) NSLog(@"couldn’t open document at %@", url);
        }];
    } else {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              /* block to execute when create is done */
              if (success) [self documentIsReady];
              if (!success) NSLog(@"couldn’t create document at %@", url);
          }];
    }
    return document;
}

-(void)documentIsReady{
    if (self.document.documentState == UIDocumentStateNormal) { // start using document
        NSLog(@"Core data document is ready!\n");
        [self fetchRestaurantsAndUpdateUI];
    } else {
        if (self.document.documentState == UIDocumentStateClosed) {
            NSLog(@"Document is closed!\n");
        } else if (self.document.documentState == UIDocumentStateEditingDisabled) {
            NSLog(@"Document editing is disabled!\n");
        } else if (self.document.documentState == UIDocumentStateSavingError) {
            NSLog(@"Document has saving error!\n");
        } else if (self.document.documentState == UIDocumentStateInConflict) {
            NSLog(@"Document has conflict!\n");
        }
    }
}

-(void)fetchRestaurantsAndUpdateUI{
    NSManagedObjectContext *context = self.document.managedObjectContext;
    NSError *error;
    self.restaurants = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Restaurant"]
                                              error:&error];
    [self.tableView reloadData];
}

-(void)synchronize{
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:^(BOOL success) {
               if(success)NSLog(@"changes saved!\n");
               else NSLog(@"changes saving failed!\n");
           }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.restaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    Restaurant *restaurant = [self.restaurants objectAtIndex:indexPath.row];
    [cell.textLabel setText:restaurant.name];
    return cell;
}

#pragma mark - Notification
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(contextChanged:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:self.document.managedObjectContext];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self
                      name:NSManagedObjectContextDidSaveNotification
                    object:self.document.managedObjectContext];
    [super viewWillDisappear:animated];
}

- (void)contextChanged:(NSNotification *)notification
{
    [self fetchRestaurantsAndUpdateUI];
}

@end
