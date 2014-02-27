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
#import <Parse/Parse.h>

@interface MTBoardViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)  IBOutlet MKMapView  *mapView;
@property (strong, nonatomic)  NSArray *placeArray;
@property (strong, nonatomic)  PFObject *boardData;
@property (weak, nonatomic) IBOutlet MTTableView *tableView;

@end
