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

@interface MTMapDetailViewController ()

@end

@implementation MTMapDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *addMapItem = [[UIBarButtonItem alloc] initWithTitle:@"Story" style:UIBarButtonItemStylePlain target:self action:@selector(showStory)];
        self.navigationItem.rightBarButtonItem = addMapItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpMapView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, self.view.frame.size.height - 400) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceSummaryCell" bundle:nil] forCellReuseIdentifier:@"PlaceSummaryCell"];

    [self.view addSubview:self.tableView];
    
   
    CGSize expectedSize = [MTViewHelper getSizebyString:[self.mapData.mapObject objectForKey:Description]];
    self.storyView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, expectedSize.height+85) style:UITableViewStylePlain];

    self.storyView.dataSource = self;
    self.storyView.delegate = self;
    [self.view addSubview:self.storyView];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.storyView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.storyView setSeparatorInset:UIEdgeInsetsZero];
    }
    [MTViewHelper setExtraCellLineHidden:self.storyView];
    

}



-(void)setUpMapView{
    self.mapView = [[RMMapView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,400) andTilesource:[[RMMapboxSource alloc] initWithMapID:MapId]];
    self.mapView.zoom = 13;
    
    [self.view addSubview:self.mapView];
    MTPlace *place = self.placeArray[0];
    [self.mapView setCenterCoordinate:place.coordinate];
    for(MTPlace *place in self.placeArray){
        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                              coordinate:place.coordinate
                                                                andTitle:place.title];
        
        annotation.userInfo = @"test";
        annotation.annotationIcon = [UIImage imageNamed:@"placepin.png"];
        [self.mapView addAnnotation:annotation];
    }
    //[self.mapView addAnnotations:self.placeArray];
    
   
    self.mapView.delegate = self;
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

#pragma mark - Action
-(void)showStory{
    if(!self.isShowStory) {
        self.isShowStory = true;
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.storyView) return 3;
    return self.placeArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.storyView){
        if(indexPath.row==1){
            CGSize expectedSize = [MTViewHelper getSizebyString:[self.mapData.mapObject objectForKey:Description]];
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
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [editButton addTarget:self action:@selector(editMap) forControlEvents:UIControlEventTouchUpInside];
            [editButton setTitle:@"Edit" forState:UIControlStateNormal];
            editButton.frame = CGRectMake(270, 10, 50, 20);
            [cell.contentView addSubview:editButton];
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
            label.text = @"New York";
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
    CLLocation *venueLocation  = [[CLLocation alloc]initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
    CLLocationDistance distance = [curLocation distanceFromLocation:venueLocation];
    label.text = [NSString stringWithFormat:@"%dm",(int)distance];
    label = (UILabel *)[cell viewWithTag:3];
    label.text = place.venueAddress;
    
    //UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
