//
//  MTLoginViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-28.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTLoginViewController.h"
#import <AVOSCloud/AVUser.h>

@interface MTLoginViewController ()

@end

@implementation MTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIStoryboard * storyBoard  = [UIStoryboard
                                      storyboardWithName:@"Main" bundle:nil];
        
        self = [storyBoard instantiateViewControllerWithIdentifier:@"Login"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(IBAction)loginClick:(id)sender{
    if(!self.accountField.text.length||!self.passwordField.text.length){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    else {
        [AVUser logInWithUsernameInBackground:self.accountField.text password:self.passwordField.text block:^(AVUser *user, NSError *error) {
            if (user) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Success", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                [self dismissViewControllerAnimated:YES completion:NULL];
                return;
                
            }else{
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Error", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                return;
            }
        }];

    
    }
    

}

-(IBAction)sighUpClick:(id)sender{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
