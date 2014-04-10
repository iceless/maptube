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
    
    [self.view addSubview:self.mapView];
    [self.mapView setCenterCoordinate:self.venue.coordinate];
    
   
    self.mapView.delegate = self;
    self.mapView.debugTiles = NO;
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                          coordinate:self.mapView.centerCoordinate
                                                            andTitle:self.venue.title];
    
    annotation.userInfo = @"test";
    annotation.annotationIcon = [UIImage imageNamed:@"placepin.png"];
    //[self.mapView ];
    [self.mapView addAnnotation:annotation];
    
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker;
     marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"placepin.png"]];
    
    
    marker.canShowCallout = YES;
    
    return marker;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
