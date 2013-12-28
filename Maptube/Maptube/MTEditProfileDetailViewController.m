//
//  MTEditProfileDetailViewController.m
//  Maptube
//
//  Created by Bing W on 12/27/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import "MTEditProfileViewController.h"
#import "MTEditProfileDetailViewController.h"

@interface MTEditProfileDetailViewController ()

@end

@implementation MTEditProfileDetailViewController

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
    
    //have to use detailwhat to pass the string value to detailtextview.text,
    //since at very beginning, you can't assign detailtextview.text from the previous view controller
    // through controller
    self.detailtextview.text = self.detailvalue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonTapAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    MTEditProfileViewController *controller = (MTEditProfileViewController *)[self.navigationController topViewController];
    controller.values[self.indexpathrow] = self.detailtextview.text;
}

@end
