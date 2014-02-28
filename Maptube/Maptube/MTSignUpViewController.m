//
//  MTSignUpViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-28.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTSignUpViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MTSignUpViewController ()

@end

@implementation MTSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(IBAction)signUpClick:(id)sender{
    
    if(!self.accountField.text.length||!self.passwordField.text.length||!self.emailField.text.length){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    else {
    AVUser *user= [AVUser user];
    user.username=self.accountField.text;
    user.password=self.passwordField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUp Success", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            [self dismissViewControllerAnimated:YES completion:NULL];
            return;

            
        }else{
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUp Error", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
             return;
        }
    }];
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
