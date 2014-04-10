//
//  MTBoardViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-17.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MTTableView.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MTBoardViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)  MKMapView  *mapView;
@property (strong, nonatomic)  NSArray *placeArray;
@property (strong, nonatomic)  PFObject *boardData;
@property (readwrite, nonatomic) BOOL switchPage;
@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic)UIScrollView *mapScrollView;

@property (strong, nonatomic)UIScrollView *tableViewScrollView;
@property (assign, nonatomic) int _contentLayerState;
@property (assign, nonatomic) bool isCollected;
@end
