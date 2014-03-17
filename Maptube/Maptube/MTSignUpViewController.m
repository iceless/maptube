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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20,84,81,21)];
    label.text = @"username:";
    [self.view addSubview:label];
    label = [[UILabel alloc]initWithFrame:CGRectMake(20,127,92,21)];
    label.text = @"password:";
    [self.view addSubview:label];
    label = [[UILabel alloc]initWithFrame:CGRectMake(20,178,46,21)];
    label.text = @"email:";
    [self.view addSubview:label];
    
    self.accountField = [[UITextField alloc]initWithFrame:CGRectMake(116,80,194,30)];
    self.accountField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.accountField];
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(116,124,194,30)];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    //self.passwordField.font = [UIFont systemFontOfSize:14];
    //self.passwordField.placeholder = @"Please input the password";
    [self.view addSubview:self.passwordField];
    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(116,169,113,30)];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.emailField];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame =  CGRectMake(104,224,99,40);
    [button setTitle:@"SignUp" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(signUpClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];



    
}

-(void)signUpClick{
    
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
