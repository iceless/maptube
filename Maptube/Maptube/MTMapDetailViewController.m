//
//  MTMapDetailViewController.m
//  Maptube
//
//  Created by Vivian on 14-4-14.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTMapDetailViewController.h"
#import "MTPlace.h"
#import "MTEditBoardViewController.h"
#import "MTPlaceIntroductionViewController.h"


@interface MTMapDetailViewController ()

@end

@implementation MTMapDetailViewController

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
    [self setUpMapView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 24, 24);
    [button setImage:[UIImage imageNamed:@"story.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showStory) forControlEvents:UIControlEventTouchUpInside];
    [self useCustomBackBarButtonItem];
     self.isTableViewFolded = YES;
    
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = mapItem;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 45*3-20, self.view.frame.size.width, 45*3+20) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceSummaryCell" bundle:nil] forCellReuseIdentifier:@"PlaceSummaryCell"];
    [self.view addSubview:self.tableView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFold)];
    [view addGestureRecognizer:headTap];
    CGAffineTransform transform =CGAffineTransformMakeScale(2.0f,2.0f);
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(298, 0, 15, 15);
    headButton.transform = transform;
    headButton.tag = 11;
    
   
    if(self.isTableViewFolded){
        [headButton setImage:[UIImage imageNamed:@"mapdetail_list button-1.png"] forState:UIControlStateNormal];
    }
    else{
        [headButton setImage:[UIImage imageNamed:@"mapdetail_list button-2.png"] forState:UIControlStateNormal];
        
    }
    
    [view addSubview:headButton];
    //[headButton addTarget:self action:@selector(clickFold) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableHeaderView:view];
    
   

    
    
   
    CGSize expectedSize = [MTData getSizebyString:[self.mapData.mapObject objectForKey:Description]];
    self.storyViewHeight = expectedSize.height+85;
    self.storyView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, expectedSize.height+85) style:UITableViewStylePlain];
    self.storyView.hidden = YES;
    self.isShowStory = NO;
   
    self.storyView.dataSource = self;
    self.storyView.delegate = self;
    [self.view addSubview:self.storyView];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.storyView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.storyView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self setExtraCellLineHidden:self.storyView];
    [self setExtraCellLineHidden:self.tableView];
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}



-(void)setUpMapView{
    self.mapView = [[RMMapView alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width,380) andTilesource:[[RMMapboxSource alloc] initWithMapID:MapId]];
    self.mapView.delegate = self;
    self.mapView.zoom = 13;
    
    [self.view addSubview:self.mapView];
    MTPlace *place = self.placeArray[0];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(place.latitude.doubleValue,
                                                                 place.longitude.doubleValue)];
    for(MTPlace *place in self.placeArray){
        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                              coordinate:CLLocationCoordinate2DMake(place.latitude.doubleValue,
                                                                                                    place.longitude.doubleValue)
                                                                andTitle:place.title];
        
        annotation.userInfo = @"test";
        annotation.annotationIcon = [UIImage imageNamed:@"placepin.png"];
        [self.mapView addAnnotation:annotation];
       
    }
   
    
    
   
    
    
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

#pragma mark - Action
-(void)showStory{
    if(!self.isShowStory) {
        self.isShowStory = true;
        CGRect frame = self.storyView.frame;
        frame.size.height = 0;
        self.storyView.frame = frame;
        frame.size.height = self.storyViewHeight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.storyView.frame = frame;
        self.storyView.hidden = NO;
    }
    else {
        self.isShowStory = false;
        self.storyView.hidden = YES;
    }
}


-(void)editMap{
    
    NSMutableArray *array = [NSMutableArray array];
    array[0] = [self.mapData.mapObject objectForKey:Title];
    if([self.mapData.mapObject objectForKey:Description])
        array[1] = [self.mapData.mapObject objectForKey:Description];
    else array[1] = @"";
    if([self.mapData.mapObject objectForKey:Category])
        array[2] =[self.mapData.mapObject objectForKey:Category];
    else array[2] = @"";
    if([self.mapData.mapObject objectForKey:Secret]){
        array[3] = [self.mapData.mapObject objectForKey:Secret];
    }
    else array[3] = @"";
    
    MTEditBoardViewController *controller = [[MTEditBoardViewController alloc]initWithData:array andPFObject:self.mapData.mapObject];
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)collect{
    
    PFRelation *relation = [self.mapData.mapObject relationforKey:CollectUser];
    AVUser *user = [AVUser currentUser];
    PFRelation *mapRelation = [user relationforKey:CollectMap];
    if(!self.isCollected){

        [relation addObject:user];
        [mapRelation addObject:self.mapData.mapObject];
        self.isCollected = YES;
    }
    
    
    else{
        [mapRelation removeObject:self.mapData.mapObject];
        [relation removeObject:user];
        
        self.isCollected = NO;
    }
    [user saveEventually];
    [self.mapData.mapObject saveEventually];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView==self.storyView) return 3;
    return self.placeArray.count;
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.storyView){
        if(indexPath.row==1){
            CGSize expectedSize = [MTData getSizebyString:[self.mapData.mapObject objectForKey:Description]];
            return expectedSize.height+10;
        }
        else return 40;
    }
    
    return 45;
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.storyView){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if(indexPath.row==0){
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40,10,200,21)];
            [cell.contentView addSubview:label];
            NSString *str = [self.mapData.author objectForKey:@"username"];
            label.text = str;
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
            [cell.contentView addSubview:imgView];
            imgView.image = self.mapData.authorImage;
            imgView.layer.masksToBounds = YES;
            imgView.layer.cornerRadius =15;
            [cell.contentView addSubview:imgView];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(270, 10, 50, 20);
            AVUser *user = self.mapData.author;
            NSString *userID = [[AVUser currentUser] objectId];
            if([[user objectId] isEqualToString:userID])
            {
                [button addTarget:self action:@selector(editMap) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"Edit" forState:UIControlStateNormal];
            }
            else{
                [button addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"Collect" forState:UIControlStateNormal];
                
                
            }

            
          
            
            [cell.contentView addSubview:button];
        }
        else if(indexPath.row==1){
            UILabel *descriptionLabel = [[UILabel alloc] init];
            descriptionLabel.font = [UIFont systemFontOfSize:12];
            descriptionLabel.text = [self.mapData.mapObject objectForKey:Description];;
            descriptionLabel.numberOfLines = 0;
            CGSize maximumLabelSize = CGSizeMake(310, 300);
            CGSize expectedSize = [descriptionLabel sizeThatFits:maximumLabelSize];
            descriptionLabel.frame = CGRectMake(5, 5, 310, expectedSize.height);
            [cell.contentView addSubview:descriptionLabel];
        }
        else{
            UILabel *label = [[UILabel alloc]init];
            NSArray *array = self.mapData.mapObject[City];
            MTPlace *place = self.mapData.placeArray[0];
            if(array||array.count==0){
                [AFHelper AFConnectionWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/geocode/%f,%f.json",MapBoxAPI,MapId,place.longitude.doubleValue,place.latitude.doubleValue]] andStr:nil compeletion:^(id data){
                    
                    NSDictionary *dict = data;
                    NSString *str =  [MTData getCity:dict];
                    label.text = str;
                    
                }];
                
                
            }
            //label.text = @"New York";
            label.font = [UIFont systemFontOfSize:12];
            label.frame = CGRectMake(5, 5, 80, 20);
            [cell.contentView addSubview:label];
        }
        return cell;
    }
    static NSString *CellIdentifier = @"PlaceSummaryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    MTPlace *place = self.placeArray[indexPath.row];
    
    label.text = place.title;
    label = (UILabel *)[cell viewWithTag:2];
    CLLocation *curLocation  = [[CLLocation alloc]initWithLatitude:[MTData sharedInstance].curCoordinate.latitude longitude:[MTData sharedInstance].curCoordinate.longitude];
    CLLocation *venueLocation  = [[CLLocation alloc]initWithLatitude:place.latitude.doubleValue longitude:place.longitude.doubleValue];
    CLLocationDistance distance = [curLocation distanceFromLocation:venueLocation];
    label.text = [NSString stringWithFormat:@"%dm",(int)distance];
    label = (UILabel *)[cell viewWithTag:3];
    label.text = place.venueAddress;
    
    if(indexPath.row==0) cell.backgroundColor = [UIColor yellowColor];
    //UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MTPlace *place = self.placeArray[indexPath.row];
    //FSVenue *venue = [[FSVenue alloc]init];
   // venue.location.coordinate = place.coordinate;
   // venue.name = place.title;
   // venue.venueId = place.venueId;
   // venue.location.address = place.venueAddress;
    //venue.location.distance = place.distance;
    CLLocation *curLocation  = [[CLLocation alloc]initWithLatitude:[MTData sharedInstance].curCoordinate.latitude longitude:[MTData sharedInstance].curCoordinate.longitude];
    CLLocation *venueLocation  = [[CLLocation alloc]initWithLatitude:place.latitude.doubleValue longitude:place.longitude.doubleValue];
    CLLocationDistance distance = [curLocation distanceFromLocation:venueLocation];
    //venue.location.distance = [NSNumber numberWithInt:(int)distance];
    MTPlaceIntroductionViewController *controller = [[MTPlaceIntroductionViewController  alloc]init];
    controller.map = self.mapData;
    controller.mapPlaceArray = self.placeArray;
    controller.place = place;
    //[controller initData];
    [self.navigationController pushViewController:controller animated:YES];
    /*
    [AFHelper AFConnectionWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=XNXP3PLBA3LDVIT3OFQVWYQWMTHKIJHFWWSKRZJMVLXIJPUJ&client_secret=GYZFXWJVXBB1B2BFOQDKWJAQ4JXA5QIJNKHOJJHCRYRC0KWZ&v=20131109",place.venueId]] andStr:nil compeletion:^(id data){
        //获取Foursquare venue信息
        NSDictionary *dict = data;
        dict = [dict objectForKey:@"response"];
        dict = [dict objectForKey:@"venue"];
        //controller.venue = venue;
        controller.placeData = dict;
        [controller initData];
        
    }];
    */

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView==self.tableView&&self.isTableViewFolded){
        //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSArray *cellArray = [self.tableView visibleCells];
        for(int i = 1;i<cellArray.count;i++){
             UITableViewCell *cell = cellArray[i];
            cell.backgroundColor = [UIColor whiteColor];
        }
        UITableViewCell *cell = cellArray[0];
        cell.backgroundColor = [UIColor yellowColor];
        
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        MTPlace *place = self.placeArray[path.row];
        
        for(RMAnnotation *annotation in self.mapView.annotations){
            RMMarker *marker = (RMMarker *)annotation.layer;
            if(place.latitude.doubleValue == annotation.coordinate.latitude&&place.longitude.doubleValue == annotation.coordinate.longitude){
                
                [marker replaceUIImage:[UIImage imageNamed:@"location_red.png"]];
            }
            else {
                [marker replaceUIImage:[UIImage imageNamed:@"location_blue.png"]];
            }
            
        }
        
        
        
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    
    
    
}

-(void)clickFold{
    CGRect foldRect = CGRectMake(0, self.view.frame.size.height - 45*3-20, self.view.frame.size.width, 45*3+20);
    CGRect unFoldRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height );
     UIButton *button = (UIButton *)[self.tableView.tableHeaderView viewWithTag:11];
    
    if(!self.isTableViewFolded) {
        self.isTableViewFolded = true;
        self.tableView.frame = unFoldRect;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.tableView.frame = foldRect;
        [button setImage:[UIImage imageNamed:@"mapdetail_list button-1"] forState:UIControlStateNormal];
       
       
    }
    else {
        self.isTableViewFolded = false;
        self.tableView.frame = foldRect;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.tableView.frame = unFoldRect;
        [button setImage:[UIImage imageNamed:@"mapdetail_list button-2"] forState:UIControlStateNormal];
     
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
