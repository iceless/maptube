//
//  MTBoardViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-17.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTBoardViewController.h"
#import "FSVenue.h"
#import "MTPlace.h"
#import "MTPlaceIntroductionViewController.h"
#import "MTEditBoardViewController.h"
#import "UIView+GeometryShortAccess.h"

#define BECH_OFFSET_X 40
#define BECH_OFFSET_Y 40

#define CONTENT_LAYER_STATE_FULL 0
#define CONTENT_LAYER_STATE_BOTT 1
#define CONTENT_LAYER_STATE_ANIMATION 2

@interface MTBoardViewController () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation MTBoardViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,360,480)];
    //[self.view addSubview:self.mapView];
    
    
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled=YES;
    self.mapView.showsUserLocation=NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    if(self.placeArray.count!=0){
        CGRect placeRect = [MTPlace updateMemberPins:self.placeArray];
        CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(placeRect.origin.x, placeRect.origin.y);
        
        //MTPlace *place = self.placeArray[0];
        int distance = placeRect.size.width;
        distance = MAX(1500,distance);
        distance = MIN(2000000,distance);
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(coodinate,distance,distance);
        [self.mapView setRegion:region animated:TRUE];
        [self.mapView addAnnotations:self.placeArray];
    }
    
        UIButton * button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 40, 32);
    [button addTarget:self action:@selector(editBoard) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem * barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barItem;
    
    
    [self configViewHierarchy];
    
   
    
}

- (void)configViewHierarchy{
    self.mapScrollView = [[UIScrollView alloc] initWithFrame:self.mapView.bounds];
    self.mapScrollView.x = -BECH_OFFSET_X;
    self.mapScrollView.y = (44 - BECH_OFFSET_Y);
    self.mapScrollView.delegate = self;
    self.mapScrollView.userInteractionEnabled = NO;
    self.mapScrollView.minimumZoomScale = 1;
    self.mapScrollView.maximumZoomScale = 2;
    [self.mapScrollView addSubview:self.mapView];
    [self.view addSubview:self.mapScrollView];
    
   
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (20 + 44 + 80), self.view.frame.size.width, self.view.frame.size.height-20-44-80) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceSummaryCell" bundle:nil] forCellReuseIdentifier:@"PlaceSummaryCell"];
    UIView *footView = [[UIView alloc] initWithFrame:self.view.frame];
    footView.backgroundColor = [UIColor whiteColor];
    //    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(contentSwipped:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.tableView addGestureRecognizer:swipe];

    
    
    // content scrollview
    self.tableViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20 + 44 , 320, self.view.height - 20 - 44)];
    self.tableViewScrollView.contentSize = CGSizeMake(320, self.tableView.frame.size.height+120);
    self.tableViewScrollView.backgroundColor = [UIColor clearColor];
    self.tableViewScrollView.showsHorizontalScrollIndicator = self.tableViewScrollView.showsVerticalScrollIndicator = YES;
    self.tableViewScrollView.delegate = self;
    self._contentLayerState = CONTENT_LAYER_STATE_FULL;
    [self.view addSubview:self.tableViewScrollView];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == self.mapScrollView) {
        return self.mapView;
    }
    else{
        return Nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableViewScrollView) {
        if ((self._contentLayerState == CONTENT_LAYER_STATE_FULL) &&
            (self._contentLayerState != CONTENT_LAYER_STATE_ANIMATION)) {
            self.mapScrollView.y = (44 - BECH_OFFSET_Y) + - scrollView.contentOffset.y / 9;
            self.tableView.y = (20 + 44 + 80) + (-scrollView.contentOffset.y);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.tableViewScrollView) {
        if (scrollView.contentOffset.y <= -90) {
            self._contentLayerState = CONTENT_LAYER_STATE_ANIMATION;
            self.tableViewScrollView.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.25F animations:^{
                self.tableView.y = (20 + 44 + 80) + 240;
                self.tableView.scrollEnabled = NO;
                self.mapScrollView.zoomScale = 1.2;
                
                //self.tableView.y = self.view.height;
            } completion:^(BOOL finished) {
                self._contentLayerState = CONTENT_LAYER_STATE_BOTT;
            }];
        }
    }
}

- (void)contentSwipped:(UISwipeGestureRecognizer *)ges
{
    self._contentLayerState = CONTENT_LAYER_STATE_ANIMATION;
    [UIView animateWithDuration:0.25F animations:^{
        self.tableView.y = (20 + 44 + 80);
        self.mapScrollView.y = (44 - BECH_OFFSET_Y);
        self.mapScrollView.zoomScale = 1;
        
        //self.tableView.y = self.view.height - self.tableView.height;
    } completion:^(BOOL finished) {
        self._contentLayerState = CONTENT_LAYER_STATE_FULL;
        self.tableViewScrollView.userInteractionEnabled = YES;
        self.tableView.scrollEnabled = YES;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.switchPage = NO;
    [super viewWillAppear:animated];
}

/*
#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}
-(void) touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
	//CGPoint pt = [[touches anyObject] locationInView:self.view];
	
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    if(CGRectContainsPoint(self.mapView.frame, pt)){
        
    }
	
}
 */
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PlaceSummaryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    MTPlace *place = self.placeArray[indexPath.row];
    
    label.text = place.name;
    label = (UILabel *)[cell viewWithTag:2];
    CLLocation *curLocation  = [[CLLocation alloc]initWithLatitude:[MTData sharedInstance].curCoordinate.latitude longitude:[MTData sharedInstance].curCoordinate.longitude];
    CLLocation *venueLocation  = [[CLLocation alloc]initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
    CLLocationDistance distance = [curLocation distanceFromLocation:venueLocation];
    label.text = [NSString stringWithFormat:@"%dm",(int)distance];

    
    label = (UILabel *)[cell viewWithTag:3];
    label.text = place.venueAddress;
    
    //UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.switchPage) return;
    self.switchPage = true;
    MTPlace *place = self.placeArray[indexPath.row];
    FSVenue *venue = [[FSVenue alloc]init];
    venue.location.coordinate = place.coordinate;
    venue.name = place.name;
    venue.venueId = place.venueId;
    venue.location.address = place.venueAddress;
    //venue.location.distance = place.distance;
    CLLocation *curLocation  = [[CLLocation alloc]initWithLatitude:[MTData sharedInstance].curCoordinate.latitude longitude:[MTData sharedInstance].curCoordinate.longitude];
    CLLocation *venueLocation  = [[CLLocation alloc]initWithLatitude:venue.location.coordinate.latitude longitude:venue.location.coordinate.longitude];
    CLLocationDistance distance = [curLocation distanceFromLocation:venueLocation];
    venue.location.distance = [NSNumber numberWithInt:(int)distance];
    
    [AFHelper AFConnectionWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=XNXP3PLBA3LDVIT3OFQVWYQWMTHKIJHFWWSKRZJMVLXIJPUJ&client_secret=GYZFXWJVXBB1B2BFOQDKWJAQ4JXA5QIJNKHOJJHCRYRC0KWZ&v=20131109",place.venueId]] andStr:nil compeletion:^(id data){
        //获取Foursquare venue信息
        
        NSDictionary *dict = data;
        dict = [dict objectForKey:@"response"];
        dict = [dict objectForKey:@"venue"];
        MTPlaceIntroductionViewController *controller = [[MTPlaceIntroductionViewController  alloc]initWithData:dict AndVenue:venue];
        [self.navigationController pushViewController:controller animated:YES];
        
    }];

    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  UITableViewCellEditingStyleDelete;
    
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFRelation *placeRelation = [self.boardData relationforKey:Place];
    [placeRelation removeObject:[self.placeArray objectAtIndex:indexPath.row]];
    [self.boardData saveInBackground];
    NSMutableArray *placeMutableArray = self.placeArray.mutableCopy;
    [placeMutableArray removeObjectAtIndex:indexPath.row];
    self.placeArray = placeMutableArray;
    [self.tableView reloadData];
    

}

-(void)editBoard{
    
    NSMutableArray *array = [NSMutableArray array];
    array[0] = [self.boardData objectForKey:Title];
    if([self.boardData objectForKey:Description])
    array[1] = [self.boardData objectForKey:Description];
    else array[1] = @"";
    if([self.boardData objectForKey:Category])
        array[2] =[self.boardData objectForKey:Category];
    else array[2] = @"";
    if([self.boardData objectForKey:Secret]){
        array[3] = [self.boardData objectForKey:Secret];
    }
    else array[3] = @"";
    
    MTEditBoardViewController *controller = [[MTEditBoardViewController alloc]initWithData:array andPFObject:self.boardData];
    [self.navigationController pushViewController:controller animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
