//
//  MTAddCollectionViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-14.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTAddCollectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic ) UITableView *table;
@end
