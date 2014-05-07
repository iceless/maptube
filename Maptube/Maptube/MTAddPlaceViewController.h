//
//  MTMapViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-14.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mapbox.h"

@interface MTAddPlaceViewController : MTBaseViewController<CLLocationManagerDelegate,RMMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
   
}
@property (strong, nonatomic) RMMapView  *mapView;
@property (strong, nonatomic) NSArray *nearbyPlaces;
@property (strong,nonatomic )  UITableView *table;
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (strong, nonatomic)  CLLocation  *curLocation;
@property (strong, nonatomic)  UIView *footer;
@property (nonatomic, strong)  UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearching;



@end
