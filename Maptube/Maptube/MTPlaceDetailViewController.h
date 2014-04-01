//
//  MTPlaceDetailViewController.h
//  Maptube
//
//  Created by Vivian on 14-3-28.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mapbox.h"
#import "FSVenue.h"
#import "MTChooseBoardViewController.h"
@interface MTPlaceDetailViewController : UIViewController<RMMapViewDelegate>
@property (strong, nonatomic) RMMapView  *mapView;
@property (strong, nonatomic) FSVenue *venue;
@property (strong, nonatomic) NSDictionary *placeData;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) MTChooseBoardViewController *chooseBoardView;
@end
