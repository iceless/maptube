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

- (id)initWithVenue:(FSVenue *)venue{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.venue = venue;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
     self.mapView = [[RMMapView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) andTilesource:[[RMMapboxSource alloc] initWithMapID:MapId]];
    
     //self.mapView.mapType = MKMapTypeStandard;
    // self.mapView.zoomEnabled=NO;
    // self.mapView.scrollEnabled = NO;
    // self.mapView.showsUserLocation=NO;
    [self.view addSubview:self.mapView];
    [self.mapView setCenterCoordinate:self.venue.coordinate];
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                           coordinate:self.mapView.centerCoordinate
                                                             andTitle:self.venue.title];
    
    annotation.userInfo = @"test";
     //[self.mapView ];
    [self.mapView addAnnotation:annotation];
    self.mapView.delegate = self;
         
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker;
    
    if ([annotation.userInfo isEqualToString:@"small"])
    {
        marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"factory_small.png"]];
    }
    else if ([annotation.userInfo isEqualToString:@"big"])
    {
        marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"factory_big.png"]];
    }
    
    marker.canShowCallout = YES;
    
    return marker;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
