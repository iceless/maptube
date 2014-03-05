//
//  MTMapViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-14.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MTAddPlaceViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
   
}
@property (strong, nonatomic)  IBOutlet MKMapView  *mapView;
@property (strong, nonatomic) NSArray *nearbyPlaces;
@property (strong,nonatomic )  IBOutlet UITableView *table;
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (strong, nonatomic)  CLLocation  *curLocation;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearching;


@end
