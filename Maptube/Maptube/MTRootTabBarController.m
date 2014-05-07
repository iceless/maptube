//
//  MTRootTabBarController.m
//  Maptube
//
//  Created by Bing W on 12/24/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "MTRootTabBarController.h"
#import <AVOSCloud/AVUser.h>
#import "MTLoginViewController.h"


@interface MTRootTabBarController ()

@end

@implementation MTRootTabBarController

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
    
    self.title = @"Maptube";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![AVUser currentUser]) { // No user logged in
        // Create the log in view controller
        /*
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
         */
        MTLoginViewController *logInViewController = [[MTLoginViewController alloc]init];
        
        // Assign our sign up controller to be displayed from the login controller
        //[logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    else {
       [MTData sharedInstance];
    }
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
