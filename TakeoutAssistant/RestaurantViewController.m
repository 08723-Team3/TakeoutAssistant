//
//  RestaurantViewController.m
//  TakeoutAssistant
//
//  Created by Gang Wu on 7/30/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import "RestaurantViewController.h"
#import <CoreData/CoreData.h>

@interface RestaurantViewController ()
@property (nonatomic, strong) UIManagedDocument *document;
@end

@implementation RestaurantViewController

#pragma mark - Properties

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

-(UIManagedDocument *)document{
    if(!_document) _document = [self createDocument];
    return _document;
}

-(void)documentIsReady{
    if (self.document.documentState == UIDocumentStateNormal) { // start using document
        NSLog(@"Core data document is ready!\n");
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

#pragma mark - Table View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Notification
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(contextChanged:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:self.document.managedObjectContext]; //don’tpassnilhere!
}
- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self
                      name:NSManagedObjectContextDidSaveNotification
                    object:self.document.managedObjectContext];
    [super viewWillDisappear:animated];
}

- (void)contextChanged:(NSNotification *)notification{
    
}

@end
