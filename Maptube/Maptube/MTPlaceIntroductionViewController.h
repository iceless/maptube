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
@interface MTPlaceIntroductionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSDictionary *placeData;
@property (strong, nonatomic) FSVenue *venue;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *boardArray;
//@property (strong, nonatomic) IBOutlet MKMapView  *mapView;
@property (strong, nonatomic) MTChooseBoardViewController *chooseBoardView;
-(id)initWithData:(NSDictionary *)dict AndVenue:(FSVenue *)venue;
@end
