//
//  MTPlaceDetailViewController.m
//  Maptube
//
//  Created by Vivian on 14-3-28.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTPlaceDetailViewController.h"
#import "MTPlaceImageViewController.h"


@interface MTPlaceDetailViewController ()

@end

@implementation MTPlaceDetailViewController

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
    
     self.imageUrlArray = [[NSMutableArray alloc]init];
    self.mapView = [[RMMapView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) andTilesource:[[RMMapboxSource alloc] initWithMapID:MapId]];
    
    [self.view addSubview:self.mapView];
    [self.mapView setCenterCoordinate:self.venue.coordinate];
    
    
    self.mapView.delegate = self;
    self.mapView.debugTiles = NO;
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                          coordinate:self.mapView.centerCoordinate
                                                            andTitle:self.venue.title];
    //annotation.annotationIcon = [UIImage imageNamed:@"placepin.png"];
    
    annotation.userInfo = @"test";
    [self initImageURL];
    self.imgView = [[UIImageView alloc] init];
    self.imgView.frame = CGRectMake(0, 0, 30, 30);
    //[self.mapView ];
    
    AFImageRequestOperation *operation;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self.imageUrlArray objectAtIndex:0]]];
    
    operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.imgView.image = image;
            [self.mapView addAnnotation:annotation];
        }  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
    }];
    [operation start];
    
}

-(void)initImageURL{
    NSDictionary *pictureDict = [self.placeData objectForKey:@"photos"];
    NSArray *array = [pictureDict objectForKey:@"groups"];
    if(array.count!=0){
        pictureDict = [array objectAtIndex:0];
        NSArray *picArray = [pictureDict objectForKey:@"items"];
        if(picArray.count!=0){
            for (int i=0; i<picArray.count; i++) {
                
                
                NSDictionary *picDict = [picArray objectAtIndex:i];
                NSString *str= [picDict objectForKey:@"prefix"];
                str = [str stringByAppendingString:@"300x300"];
                str = [str stringByAppendingString:[picDict objectForKey:@"suffix"]];
                //NSLog(@"%@",str);
                [self.imageUrlArray addObject:str];
                
                
            }
            
        }
    }
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker;
    marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"placepin.png"]];
    
    
    marker.canShowCallout = YES;
   
    
    marker.leftCalloutAccessoryView = self.imgView;
    
     //marker.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like.png"]];
    marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return marker;
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    MTPlaceImageViewController *controller = [[MTPlaceImageViewController alloc]init];
    controller.imageUrlArray = self.imageUrlArray;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
