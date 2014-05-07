//
//  MTMapViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-14.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTAddPlaceViewController.h"
#import "FSVenue.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import "MTAddPictureViewController.h"
#import "MTPlaceIntroductionViewController.h"
//#import "MTPlaceDetailViewController.h"

@interface MTAddPlaceViewController ()

@end

@implementation MTAddPlaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
	// Do any additional setup after loading the view.
    //[self.navigationController setNavigationBarHidden:YES];
    
    self.mapView = [[RMMapView alloc]initWithFrame:CGRectMake(0,44,self.view.frame.size.width,180) andTilesource:[[RMMapboxSource alloc] initWithMapID:MapId]];
    self.mapView.zoom = 13;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = RMUserTrackingModeFollow;
    [self.view addSubview:self.mapView];
    
   
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    self.searchBar.delegate = self;
    [self.navigationController.view addSubview:self.searchBar];
    self.searchBar.tag = 3;
    self.searchBar.backgroundImage = [self createImageWithColor:[UIColor clearColor]];
    self.searchBar.placeholder = @"Find a place";
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 226, self.view.frame.size.width, self.view.frame.size.height-226-50)];
    self.table.delegate =self;
    self.table.dataSource = self;
    [self setExtraCellLineHidden:self.table];
    [self.view addSubview:self.table];
    
    self.locationManager =[[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=10.0f;
    [self.locationManager startUpdatingLocation];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = false;
    UISearchBar *searchbar = (UISearchBar *)[self.navigationController.view viewWithTag:3];
    searchbar.hidden = NO;
    [self.navigationController setNavigationBarHidden:false];
    
}

- (UIImage *)createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - Map

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"newLocation:%@",[newLocation description]);
    [manager stopUpdatingLocation];
    self.curLocation = newLocation;
    [self.mapView setCenterCoordinate:newLocation.coordinate];
    [self getVenuesForLocation:newLocation andquery:nil];
    [self.locationManager stopUpdatingLocation];
    [manager stopUpdatingLocation];
    
    
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker;
    marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"location_blue.png"]];
    marker.canShowCallout = YES;
    return marker;
}

- (void)getVenuesForLocation:(CLLocation *)location andquery:(NSString *)str {
    
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:str
                                     limit:nil
                                    intent:intentCheckin
                                    radius:@(500)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.nearbyPlaces = [converter convertToObjects:venues];
                                          [self.table reloadData];
                                          [self proccessAnnotations];
                                          
                                      }
                                  }];
}
- (void)removeAllAnnotationExceptOfCurrentUser {
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:self.mapView.annotations];
    if ([self.mapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
        [annForRemove removeObject:self.mapView.annotations.lastObject];
    } else {
        for (id <MKAnnotation> annot_ in self.mapView.annotations) {
            if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                [annForRemove removeObject:annot_];
                break;
            }
        }
    }
    
    [self.mapView removeAnnotations:annForRemove];
}

- (void)proccessAnnotations {
    [self removeAllAnnotationExceptOfCurrentUser];
    for(FSVenue *place in self.nearbyPlaces){
        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                              coordinate:place.coordinate
                                                                andTitle:place.title];
        
        annotation.userInfo = @"test";
        annotation.annotationIcon = [UIImage imageNamed:@"placepin.png"];
        [self.mapView addAnnotation:annotation];
        
    }
}

#pragma mark - SearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    // NSLog(@"shouldBeginEditing");
    self.searchBar.showsCancelButton  = YES;
    
    self.isSearching = true;
    return true;
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.isSearching = false;
    [self.table reloadData];
    searchBar.text = @"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self getVenuesForLocation:self.curLocation andquery:searchText];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.isSearching = false;
    self.searchBar.showsCancelButton  = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nearbyPlaces.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.nearbyPlaces.count) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.nearbyPlaces[indexPath.row] name];
    FSVenue *venue = self.nearbyPlaces[indexPath.row];
    if (venue.location.address) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
                                     venue.location.distance,
                                     venue.location.address];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
                                     venue.location.distance];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSVenue *venue = self.nearbyPlaces[indexPath.row];
    [AFHelper AFConnectionWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=XNXP3PLBA3LDVIT3OFQVWYQWMTHKIJHFWWSKRZJMVLXIJPUJ&client_secret=GYZFXWJVXBB1B2BFOQDKWJAQ4JXA5QIJNKHOJJHCRYRC0KWZ&v=20131109",venue.venueId]] andStr:nil compeletion:^(id data){
        //获取Foursquare venue信息
        
        NSDictionary *dict = data;
        dict = [dict objectForKey:@"response"];
        dict = [dict objectForKey:@"venue"];
        
        MTPlaceIntroductionViewController *controller = [[MTPlaceIntroductionViewController  alloc]init];
        controller.venue = venue;
        controller.placeData = dict;
        controller.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
