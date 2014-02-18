//
//  MTChooseBoardViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-18.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"
@interface MTChooseBoardViewController : UINavigationController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) FSVenue *venue;
@property (strong, nonatomic) NSArray *boardArray;
@property (strong, nonatomic) UITextField *describeTextField;
@property (strong, nonatomic) NSString *imageStr;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet  UINavigationItem *myNavigationItem;
-(id)initWithImageStr:(NSString *)str AndVenue:(FSVenue *)venue;

@end
