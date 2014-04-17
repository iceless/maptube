//
//  MTPlaceIntroductionViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-19.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"
#import "MTChooseBoardViewController.h"
#import "MTMap.h"


@interface MTPlaceIntroductionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSDictionary *placeData;
@property (strong, nonatomic) FSVenue *venue;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *boardArray;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;
@property (strong, nonatomic) MTMap *map;
@property (strong, nonatomic) NSArray *mapPlaceArray;
//@property (strong, nonatomic) IBOutlet MKMapView  *mapView;
@property (strong, nonatomic) MTChooseBoardViewController *chooseBoardView;
-(void)initData;
@end
