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
- (id)initWithValue:(NSString *)value andIndex:(NSUInteger)index{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.detailValue = value;
        self.indexPathRow = index;
        // Custom initialization
    }
    
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.detailTextView= [[UITextView alloc]initWithFrame:CGRectMake(8,82,305,196)];
    self.detailTextView.layer.borderWidth =1.0;
    self.detailTextView.layer.cornerRadius =5.0;
    self.detailTextView.layer.borderColor = [UIColor grayColor].CGColor;
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0){
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.detailTextView.text = self.detailValue;
    
    [self.view addSubview:self.detailTextView];
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 50, 32);
    [button addTarget:self action:@selector(doneButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barItem;

    
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
