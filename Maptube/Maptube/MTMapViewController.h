//
//  MTMapViewController.h
//  Maptube
//
//  Created by Vivian on 14-3-5.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FSVenue.h"
#import "Mapbox.h"

@interface MTMapViewController : UIViewController<RMMapViewDelegate>
@property (strong, nonatomic) RMMapView  *mapView;
@property (strong, nonatomic) FSVenue *venue;

- (id)initWithVenue:(FSVenue *)venue;
@end
