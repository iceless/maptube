//
//  MTMapDetailViewController.h
//  Maptube
//
//  Created by Vivian on 14-4-14.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mapbox.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MTMap.h"
@interface MTMapDetailViewController : UIViewController<RMMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) RMMapView  *mapView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *storyView;
@property (strong, nonatomic) NSArray *placeArray;
@property (strong, nonatomic) MTMap *mapData;
@property (assign, nonatomic) bool isCollected;
@property (assign, nonatomic) bool isShowStory;
@property (assign, nonatomic) int storyViewHeight;

@end
