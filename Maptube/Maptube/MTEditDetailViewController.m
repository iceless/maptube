//
//  MTEditDetailViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-17.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTEditDetailViewController.h"

@interface MTEditDetailViewController ()

@end

@implementation MTEditDetailViewController

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
    self.detailTextView.layer.borderWidth =1.0;
    self.detailTextView.layer.cornerRadius =5.0;
    self.detailTextView.layer.borderColor = [UIColor grayColor].CGColor;
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0){
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.detailTextView.text = self.detailValue;
}

- (IBAction)doneButtonTapAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate updateValue:self.detailTextView.text atIndex:self.indexPathRow];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end