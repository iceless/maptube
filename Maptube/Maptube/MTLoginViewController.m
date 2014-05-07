//
//  MTLoginViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-28.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTLoginViewController.h"
#import "MTSignUpViewController.h"
#import <AVOSCloud/AVUser.h>

@interface MTLoginViewController ()

@end

@implementation MTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(11,93,67,21)];
    label.text = @"Account:";
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    self.accountField = [[UITextField alloc]initWithFrame:CGRectMake(99,89,213,30)];
    self.accountField.font = [UIFont systemFontOfSize:14];
    self.accountField.borderStyle = UITextBorderStyleRoundedRect;
    self.accountField.placeholder = @"Please input the account";
    [self.view addSubview:self.accountField];
    label = [[UILabel alloc]initWithFrame:CGRectMake(11,142,80,21)];
    label.text = @"Password:";
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(99,138,213,30)];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.font = [UIFont systemFontOfSize:14];
    self.passwordField.placeholder = @"Please input the password";
    [self.view addSubview:self.passwordField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame =  CGRectMake(0,188,144,37);
    [button setTitle:@"SignUp" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(signUpClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(171,187,134,38);
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void)loginClick{
    if(!self.accountField.text.length||!self.passwordField.text.length){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    else {
        [AVUser logInWithUsernameInBackground:self.accountField.text password:self.passwordField.text block:^(AVUser *user, NSError *error) {
            if (user) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Success", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                [self dismissViewControllerAnimated:YES completion:NULL];
                [MTData sharedInstance];
                return;
                
            }else{
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Error", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                return;
            }
        }];

    
    }
    

}

-(void)signUpClick{
    MTSignUpViewController *controller = [[MTSignUpViewController alloc]init];
    [self presentViewController:controller animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
