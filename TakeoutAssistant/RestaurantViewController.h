//
//  RestaurantViewController.h
//  TakeoutAssistant
//
//  Created by Gang Wu on 7/30/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>


@interface RestaurantViewController : UITableViewController<G8TesseractDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)openCamera:(id)sender;
@end
