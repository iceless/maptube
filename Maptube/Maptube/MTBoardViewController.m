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
#import "MTPlaceDetailViewController.h"

// state machine.
#define CONTENT_LAYER_STATE_FULL 0      // 状态: tableView填充整个View
#define CONTENT_LAYER_STATE_BOTT 1      // 状态: tableView只保留部分在底部
#define CONTENT_LAYER_STATE_ANIMATION 2 // 状态: tableView正在做动画(非稳定状态)

// map view
#define MAPVIEW_OFFSET_Y (-40)                  // 通过该参数控制mapview在顶部预留多大的空间
#define MAPVIEW_VISUAL_HEIGHT 70               // 通过该参数控制mapview不被tableview盖住的部分的空间
// table view
#define TABLEVIEW_BOTTOM_INSET (-(480 - 20))    // 通过该参数控制tableview底部inset的大小。（为了保证tableview向上滑动时不出现透明的背景，tableview会加上一个480高的footview。因此这里需要给一个负数）
#define TABLEVIEW_BOTTOM_STATE_OFFSET 280       // 通过该参数控制tableview在状态CONTENT_LAYER_STATE_BOTT时，距离顶部的偏移量。越大，tableview显示的空间越小。

// control param.
#define SCROLL_DOWN_PARAM (-80)                 // 通过该参数控制下滑多少距离引起tableView进入状态 CONTENT_LAYER_STATE_BOTT


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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self configViewHierarchy];
}



- (void)configViewHierarchy
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 20 + 44 + MAPVIEW_OFFSET_Y, 320, 400)];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled=YES;
    self.mapView.showsUserLocation=NO;
    [self.view addSubview:self.mapView];
    
    [self setupMapView];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (20 + 44), self.view.width, self.view.height - 20 - 44 - 44) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, TABLEVIEW_BOTTOM_INSET, 0);
    self.tableView.showsHorizontalScrollIndicator = self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, MAPVIEW_VISUAL_HEIGHT)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)];
    [headerView addGestureRecognizer:headTap];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    footView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceSummaryCell" bundle:nil] forCellReuseIdentifier:@"PlaceSummaryCell"];

    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(contentSwipped:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.tableView addGestureRecognizer:swipe];

    
}

- (void)setupMapView
{
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
}

#pragma mark - Animation
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        if ((self._contentLayerState == CONTENT_LAYER_STATE_FULL) &&
            (self._contentLayerState != CONTENT_LAYER_STATE_ANIMATION)) {
            self.mapView.y = (20 + 44 + MAPVIEW_OFFSET_Y) + (-scrollView.contentOffset.y / 9);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y <= SCROLL_DOWN_PARAM) {
            [self doAnimationDown];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self._contentLayerState == CONTENT_LAYER_STATE_ANIMATION) {
        // add by shupeng
        // 通过该语句将禁止ScrollView的自动回弹。避免2个动画同时运行时导致步调不一致。
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    }

}

- (void)contentSwipped:(UISwipeGestureRecognizer *)ges
{
    [self doAnimationUp];
}

- (void)doAnimationDown
{
    self._contentLayerState = CONTENT_LAYER_STATE_ANIMATION;
    
    [UIView animateWithDuration:.25f animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.tableView.y = 20 + 44 + TABLEVIEW_BOTTOM_STATE_OFFSET;
// add by shupeng
#warning 需要在这里添加mapview放大的动画参数。
    } completion:^(BOOL finished) {
        self._contentLayerState = CONTENT_LAYER_STATE_BOTT;
        self.tableView.scrollEnabled = NO;
        self.tableView.tableHeaderView.userInteractionEnabled = NO;
    }];
}

- (void)doAnimationUp
{
    self._contentLayerState = CONTENT_LAYER_STATE_ANIMATION;
    
    [UIView animateWithDuration:0.25F animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.tableView.y = (20 + 44);
        self.mapView.y = (20 + 44 + MAPVIEW_OFFSET_Y);
// add by shupeng
#warning 需要在这里添加mpaview缩小的动画参数。
    } completion:^(BOOL finished) {
        self._contentLayerState = CONTENT_LAYER_STATE_FULL;
        self.tableViewScrollView.userInteractionEnabled = YES;
        self.tableView.scrollEnabled = YES;
        self.tableView.tableHeaderView.userInteractionEnabled = YES;
    }];
}


- (void)headerTapped:(id)sender
{
    if (self._contentLayerState == CONTENT_LAYER_STATE_FULL) {
        [self doAnimationDown];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.switchPage = NO;
    [super viewWillAppear:animated];
    [self doAnimationDown];
}

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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        
        MTPlaceDetailViewController *controller = [[MTPlaceDetailViewController  alloc]init];
        controller.venue = venue;
        controller.placeData = dict;

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
