//
//  RestaurantDetailViewController.m
//  TakeoutAssistant
//
//  Created by Z J on 8/1/15.
//  Copyright (c) 2015 Team3. All rights reserved.
//

#import "RestaurantDetailViewController.h"

@interface RestaurantDetailViewController ()
@end

@implementation RestaurantDetailViewController
@synthesize name_Res, tel_Res, addr_Res, review_Res, tag_Res, restaurantImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    name_Res.text = @"Restaurant's Name";
    tel_Res.text = [NSString stringWithFormat:@"%@%@", @"☎️ ", @"123124123"];
    addr_Res.text = @"Restaurant's Address Can be Mulptiple lines. Pittsburgh, PA";
    review_Res.text = @"Review: As everyone has mentioned the steak sandwiches are awesome.";
    tag_Res.text = @"Tag: Italian, Pizza";

    //[[restaurantImage setImage [UIImage imageNamed:@"Restaurant_thumbstail.png"]];
    // restaurantImage
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)redirectToYelp:(id)sender {
    
}

- (IBAction)sendTweet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *text = [NSString stringWithFormat:@"I love this restaurant!  %@",@"Restaurant's Name"];
        
        // The output of the request is placed in the log.
        // NSLog(@"HTTP Response: %i", [urlResponse statusCode]);
        
        [tweetSheet setInitialText:text];
        // [tweetSheet addImage:image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sureyour device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)makeCall:(id)sender {
    NSString *number = [NSString stringWithFormat:@"%@",@"1234667"];
    NSURL* callUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"tel:%@",number]];
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        // [alert release];
    }
}


@end
