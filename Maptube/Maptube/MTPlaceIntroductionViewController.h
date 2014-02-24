//
//  MTPlaceIntroductionViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-19.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"
#import <MapKit/MapKit.h>

@interface MTPlaceIntroductionViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) NSDictionary *placeData;
@property (strong, nonatomic) FSVenue *venue;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *boardArray;
@property (strong, nonatomic) IBOutlet MKMapView  *mapView;

-(id)initWithData:(NSDictionary *)dict AndVenue:(FSVenue *)venue;
@end
