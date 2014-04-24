//
//  MTMapViewController.m
//  Maptube
//
//  Created by Vivian on 14-3-5.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTMapViewController.h"
#import "Mapbox.h"

@interface MTMapViewController ()

@end

@implementation MTMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [self useCustomBackBarButtonItem];
    
    self.mapView = [[RMMapView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) andTilesource:[[RMMapboxSource alloc] initWithMapID:MapId]];
    self.mapView.zoom = 13;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    
    CLLocationCoordinate2D coordinate;
    NSString *title;
    if(self.venue) {
        coordinate = self.venue.coordinate;
        title = self.venue.title;
    }
    else {
        coordinate = CLLocationCoordinate2DMake(self.place.latitude.doubleValue, self.place.longitude.doubleValue);
        title = self.place.title;
    }
    
    [self.mapView setCenterCoordinate:coordinate];
    
   
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                          coordinate:self.mapView.centerCoordinate
                                                            andTitle:title];
    
    //annotation.userInfo = @"test";
    annotation.annotationIcon = [UIImage imageNamed:@"location_blue"];
    //[self.mapView ];
    [self.mapView addAnnotation:annotation];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker;
     marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"location_blue"]];
    
    
    marker.canShowCallout = YES;
    
    return marker;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
