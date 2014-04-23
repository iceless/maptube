//
//  MTHomeViewController.m
//  Maptube
//
//  Created by Vivian on 14-3-25.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTHomeViewController.h"
#import "MTMapCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MTPlace.h"
#import "MTMapDetailViewController.h"
#import "MTMap.h"

@interface MTHomeViewController ()

@end

@implementation MTHomeViewController

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
    self.title = @"MapTube";
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.table.delegate =self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    [self.table registerNib:[UINib nibWithNibName:@"MapCell" bundle:nil] forCellReuseIdentifier:@"MapCell"];
    self.mapList = [[NSMutableArray alloc]init];
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:RefreshTableViewNotification object:nil];

     [self updateMap];
}

-(void)refreshTableView{
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateMap{
    AVQuery *query = [AVQuery queryWithClassName:Map];
    [query addDescendingOrder:CollectUserCount];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //NSLog(@"%@",error);
        if(!error){
            for(int i=0;i<10;i++){
                MTMap *map = [[MTMap alloc]init];
                map.mapObject = objects[i];
                [map initData];
                [self.mapList addObject:map];
                if(i==9)
                    [self.table reloadData];
            }
            
        }
    }];
    
}

#pragma mark - Table view data delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mapList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MTMapCell *cell = (MTMapCell *)[tableView dequeueReusableCellWithIdentifier:@"MapCell"];
    
    MTMap *map = [self.mapList objectAtIndex:indexPath.row];
    cell.nameLabel.text = [map.mapObject objectForKey:Title];
    
    
    cell.authorLabel.text = [map.author objectForKey:@"username"];
    cell.iconImage.layer.masksToBounds = YES;
    cell.iconImage.layer.cornerRadius =15;
   
    
    cell.iconImage.image = map.authorImage;
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%d",map.collectUsers.count];

   
    cell.placeCountLabel.text = [NSString stringWithFormat:@"%d",map.placeArray.count];
    
    NSArray * array = map.placeArray;
    
    if(array.count!=0){
       
        CGRect placeRect = [MTPlace updateMemberPins:array];
        CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(placeRect.origin.x, placeRect.origin.y);
        
        //MTPlace *place = self.placeArray[0];
        int distance = placeRect.size.width;
        distance = MAX(1500,distance);
        distance = MIN(distance, 15000000);
        
        //MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(coodinate,distance,distance);
        float zoom=12;
        NSString *markStr = @"/";
        for (MTPlace *place in array){
            NSString *str = [NSString stringWithFormat:@"pin-s+48C(%f,%f),",place.longitude.doubleValue,place.latitude.doubleValue];
            markStr = [markStr stringByAppendingString:str];
        }
        markStr = [markStr substringToIndex:([markStr length]-1)];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%f,%f,%f/%.0fx%.0f.png",MapBoxAPI,MapId,markStr,coodinate.longitude,coodinate.latitude,zoom,cell.mapImageView.frame.size.width,cell.mapImageView.frame.size.height];
        [cell.mapImageView setImageWithURL:[NSURL URLWithString:urlStr]];
        cell.mapImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMapImage:)];
        [cell.mapImageView addGestureRecognizer:singleTapRecognizer];
        cell.mapImageView.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // [mapView setRegion:region animated:TRUE];
        //[mapView addAnnotations:array];
    }

    
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 185;
    
}

-(void)clickMapImage:(id)sender{
    
    NSInteger index = [(UIGestureRecognizer *)sender view].tag;
    /*
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell =  [self.table cellForRowAtIndexPath:indexPath];
    UIImageView *view = (UIImageView *)[cell.contentView viewWithTag:index];
     */
    MTMapDetailViewController *viewController = [[MTMapDetailViewController alloc] init];
    MTMap *map = [self.mapList objectAtIndex:index];
    viewController.mapData = map;
    viewController.placeArray = map.placeArray;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}

@end
