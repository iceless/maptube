//
//  MTViewHelper.m
//  Maptube
//
//  Created by Vivian on 14-3-7.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTViewHelper.h"

@interface MTViewHelper ()

@end

@implementation MTViewHelper

+ (void)setExtraCellLineHidden: (UITableView *)tableView

{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    // [view release];
    
}

+(CGSize)getSizebyString:(NSString *)str{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.text = str;
    label.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(310, 300);
    return  [label sizeThatFits:maximumLabelSize];
}

@end
