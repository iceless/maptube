//
//  MTEditBoardViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-20.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEditDetailViewController.h"

@interface MTEditBoardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MTEditDetailViewDelegate>
@property (strong,nonatomic ) IBOutlet UITableView *table;
//static string array for profile detail fields
@property (nonatomic, strong) NSArray *fields;
//mutable string array for profile detail values
@property (nonatomic, strong) NSMutableArray *values;
@end
