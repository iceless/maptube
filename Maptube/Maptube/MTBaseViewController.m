//
//  MTViewHelper.m
//  Maptube
//
//  Created by Vivian on 14-3-7.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTBaseViewController.h"

@interface MTBaseViewController ()

@end

@implementation MTBaseViewController

-(void)setExtraCellLineHidden: (UITableView *)tableView

{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    // [view release];
    
}



-(void)useCustomBackBarButtonItem{
    
    UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=CGRectMake(0, 0, 24, 24);
    [b addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [b setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc] initWithCustomView:b];
    self.navigationItem.leftBarButtonItem=barItem;
}


-(void)navBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
