//
//  MTHomeViewController.h
//  Maptube
//
//  Created by Vivian on 14-3-25.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTHomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *mapList;
@property (nonatomic, strong) NSMutableArray *placeArray;
@end
