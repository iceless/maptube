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
   
    UIBarButtonItem *pinItem = [[UIBarButtonItem alloc] initWithTitle:@"Pin" style:UIBarButtonItemStylePlain target:self action:@selector(pin:)];
    self.navigationItem.rightBarButtonItem = pinItem;

    
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
    if(self.imageUrlArray.count!=0){
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
    else [self.mapView addAnnotation:annotation];
    
    
    self.chooseBoardView = [[MTChooseBoardViewController alloc]initWithImage:nil AndVenue:self.venue];
    self.chooseBoardView.view.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
    UIView *greyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    greyView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    greyView.tag = 101;
    self.chooseBoardView.view.tag = 102;
    greyView.hidden = true;
    self.chooseBoardView.view.hidden = true;
    [[UIApplication sharedApplication].keyWindow addSubview:greyView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.chooseBoardView.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeChooseBoardView) name:CloseChooseBoardNotification object:nil];
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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

-(IBAction)pin:(id)sender {
    
    UIView *view = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:101];
    view.hidden = false;
    view = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:102];
    view.hidden = false;
    
   
}

-(void)closeChooseBoardView{
    UIView *view = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:101];
    view.hidden = true;
    view = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:102];
    view.hidden = true;
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
