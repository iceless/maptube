//
//  MTMapViewController.m
//  Maptube
//
//  Created by Vivian on 14-3-5.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTMapViewController.h"

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
    
     self.mapView.mapType = MKMapTypeStandard;
     self.mapView.zoomEnabled=NO;
     self.mapView.scrollEnabled = NO;
     self.mapView.showsUserLocation=NO;
     
     MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(self.venue.coordinate,2000 ,2000 );
     [self.mapView setRegion:region];
     [self.mapView addAnnotation:self.venue];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
