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
#import "HttpClient.h"
#import "RestaurantDetailViewController.h"

@interface RestaurantViewController ()
@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSArray *restaurants; // of Restaurant
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property UIImagePickerController *mediaPicker;
@end

@implementation RestaurantViewController


// Jing add
- (void)viewDidLoad
{
    self.mediaPicker.delegate = self;
    [super viewDidLoad];
    
    // Create a queue to perform recognition operations
    self.operationQueue = [[NSOperationQueue alloc] init];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diyCell"
                                                            forIndexPath:indexPath];
    Restaurant *restaurant = [self.restaurants objectAtIndex:indexPath.row];


    UIImageView *imageView = (UIImageView *)([cell viewWithTag:101]);
    UIImage *thumb = [UIImage imageWithData:
                      [NSData dataWithContentsOfURL:[NSURL URLWithString:restaurant.image]]];
    imageView.image = thumb;
        
    [(UILabel *)[cell viewWithTag:102] setText:restaurant.name];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.0f;
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


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Tesseract's recognition

-(void)recognizeImageWithTesseract:(UIImage *)image
{
    // Preprocess the image so Tesseract's recognition will be more accurate
    UIImage *bwImage = [image g8_blackAndWhite];
    
    // Animate a progress activity indicator
    [self.activityIndicator startAnimating];
    
    // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
    // It is assumed that there is a .traineddata file for the language pack
    // you want Tesseract to use in the "tessdata" folder in the root of the
    // project AND that the "tessdata" folder is a referenced folder and NOT
    // a symbolic group in your project
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];
    
    // Use the original Tesseract engine mode in performing the recognition
    // (see G8Constants.h) for other engine mode options
    operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    
    // Let Tesseract automatically segment the page into blocks of text
    // based on its analysis (see G8Constants.h) for other page segmentation
    // mode options
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
    
    // Optionally limit the time Tesseract should spend performing the
    // recognition
    //operation.tesseract.maximumRecognitionTime = 1.0;
    
    // Set the delegate for the recognition to be this class
    // (see `progressImageRecognitionForTesseract` and
    // `shouldCancelImageRecognitionForTesseract` methods below)
    operation.delegate = self;
    
    // Optionally limit Tesseract's recognition to the following whitelist
    // and blacklist of characters
    //operation.tesseract.charWhitelist = @"01234";
    //operation.tesseract.charBlacklist = @"56789";
    
    // Set the image on which Tesseract should perform recognition
    operation.tesseract.image = bwImage;
    
    // Optionally limit the region in the image on which Tesseract should
    // perform recognition to a rectangle
    //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
    
    // Specify the function block that should be executed when Tesseract
    // finishes performing recognition on the image
    operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
        // Fetch the recognized text
        NSString *recognizedText = tesseract.recognizedText;
        
        NSLog(@"%@", recognizedText);
        
        NSMutableString *num = [[NSMutableString alloc]init];
        for (NSInteger i = 0; i < [recognizedText length]; i++) {
            char c = [recognizedText characterAtIndex:i];
            if (c >= '0' && c <= '9') {
                if ([num length] == 0 && c != '4') continue;
                NSString *s = [NSString stringWithFormat:@"%c", c];
                [num appendString:s];
            }
            if ([num length] == 10) break;
            
        }

        NSLog(@"num: %@", num);
        NSDictionary *res = [HttpClient searchByPhone:num];
        if (!res) {
            res = [HttpClient searchByPhone:@"4126211773"];
        }
        
        // Remove the animated progress activity indicator
        [self.activityIndicator stopAnimating];
        
        
        // create a new restaurant
        Restaurant *restaurant = [Restaurant createWithContext:self.document.managedObjectContext];
        
        restaurant.name = [res objectForKey:@"name"];
        restaurant.phone = [res objectForKey:@"display_phone"];

        restaurant.image = [res objectForKey:@"image_url"];
        restaurant.rating = [res objectForKey:@"rating_img_url"];
        restaurant.review = [res objectForKey:@"snippet_text"];
        restaurant.url = [res objectForKey:@"url"];
        

        NSDictionary *loc = [res objectForKey:@"location"];
        restaurant.city = [loc objectForKey:@"city"];
        NSArray *addr = [loc objectForKey:@"address"];
        restaurant.address = addr[0];
        restaurant.state = [loc objectForKey:@"state_code"];
        restaurant.postcode = [loc objectForKey:@"postal_code"];

        NSArray *cates = [res objectForKey:@"categories"];
        NSMutableString *tags = [[NSMutableString alloc]init];
        for (NSInteger i = 0; i < [cates count]; i++) {
            [tags appendFormat:@"%@ ", cates[i][0]];
        }
        restaurant.tags = tags;
        
        
        [self synchronize];
    };
    
    // Finally, add the recognition operation to the queue
    [self.operationQueue addOperation:operation];
}

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can observe the progress.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 */
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can cancel the recogntion
 *  prematurely if necessary.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 *
 *  @return Whether or not to cancel the recognition.
 */
- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to cancel recognition prematurely
}
/*
- (IBAction)openCamera:(id)sender
{
    UIImagePickerController *imgPicker = [UIImagePickerController new];
    imgPicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}
 */
- (IBAction)openCamera:(id)sender
{
    self.mediaPicker = [[UIImagePickerController alloc] init];
    [self.mediaPicker setDelegate:self];
    self.mediaPicker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];

    } else {
        self.mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.mediaPicker animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.mediaPicker animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        self.mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.mediaPicker animated:YES completion:nil];
    } else {
       [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}


- (IBAction)recognizeSampleImage:(id)sender {
    [self recognizeImageWithTesseract:[UIImage imageNamed:@"image_sample.jpg"]];
}

- (IBAction)clearCache:(id)sender
{
    [G8Tesseract clearCache];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self recognizeImageWithTesseract:image];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Restaurant *r = [self.restaurants objectAtIndex:indexPath.row ];
    RestaurantDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"detailStoryId"];
    view.restaurant = r;
    [self.navigationController pushViewController:view animated:YES];
    
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30.0f)];
    [view setBackgroundColor:[UIColor grayColor]];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 150, 20)];
    [lbl setFont:[UIFont systemFontOfSize:14]];
    [lbl setTextColor:[UIColor whiteColor]];
    [view addSubview:lbl];
    
    [lbl setText:[NSString stringWithFormat:@"%ld restaurants", [self.restaurants count]]];
    
    return view;
}

@end
