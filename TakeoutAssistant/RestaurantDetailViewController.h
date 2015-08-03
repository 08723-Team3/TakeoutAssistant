//
//  RestaurantDetailViewController.h
//  TakeoutAssistant
//
//  Created by Z J on 8/1/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <sys/sysctl.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Restaurant.h"

@interface RestaurantDetailViewController : UIViewController
@property (strong, nonatomic) Restaurant *restaurant;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UILabel *name_Res;
@property (weak, nonatomic) IBOutlet UILabel *tel_Res;
@property (weak, nonatomic) IBOutlet UITextView *addr_Res;
@property (weak, nonatomic) IBOutlet UITextView *review_Res;
@property (weak, nonatomic) IBOutlet UILabel *tag_Res;
- (IBAction)redirectToYelp:(id)sender;
- (IBAction)sendTweet:(id)sender;
- (IBAction)makeCall:(id)sender;

@end
