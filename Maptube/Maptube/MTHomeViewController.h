//
//  MTHomeViewController.h
//  Maptube
//
//  Created by Vivian on 14-3-25.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTHomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *mapList;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *mapSearchArray;
@property (nonatomic, strong) NSMutableArray *userSearchArray;
@property (nonatomic, assign) BOOL isSearching;
@end
