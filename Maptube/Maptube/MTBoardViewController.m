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

@interface MTBoardViewController ()

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
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(coodinate,distance,distance);
        [self.mapView setRegion:region animated:TRUE];
        [self.mapView addAnnotations:self.placeArray];
    }
    
    self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height-40);
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 50, 32);
    [button addTarget:self action:@selector(editBoard) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem * barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barItem;
   
    

}

-(void)viewDidLayoutSubviews {
    
    self.tabBarController.tabBar.hidden = false;
    
    [super viewDidLayoutSubviews];
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.mapView.frame.size.height+80, 0, 0, 0);
    
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < (self.mapView.frame.size.height+80)*-1 ) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, (self.mapView.frame.size.height+80)*-1)];
    }
    
   
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
    static NSString *CellIdentifier = @"PlaceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    MTPlace *place = self.placeArray[indexPath.row];
    label.text = place.name;
    
    //UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MTPlace *place = self.placeArray[indexPath.row];
    FSVenue *venue = [[FSVenue alloc]init];
    venue.location.coordinate = place.coordinate;
    venue.name = place.name;
    venue.venueId = place.venueId;
    venue.location.address = place.venueAddress;
    venue.location.distance = place.distance;
    
    
    [AFHelper AFConnectionWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=XNXP3PLBA3LDVIT3OFQVWYQWMTHKIJHFWWSKRZJMVLXIJPUJ&client_secret=GYZFXWJVXBB1B2BFOQDKWJAQ4JXA5QIJNKHOJJHCRYRC0KWZ&v=20131109",place.venueId]] andStr:nil compeletion:^(id data){
        //获取Foursquare venue信息
        
        NSDictionary *dict = data;
        dict = [dict objectForKey:@"response"];
        dict = [dict objectForKey:@"venue"];
        MTPlaceIntroductionViewController *controller = [[MTPlaceIntroductionViewController  alloc]initWithData:dict AndVenue:venue];
        [self.navigationController pushViewController:controller animated:YES];
        
        
    }];

    
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
