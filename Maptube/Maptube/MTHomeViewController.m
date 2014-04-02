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

     [self updateMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateMap{
    AVQuery *query = [AVQuery queryWithClassName:Map];
    //[query addDescendingOrder:CollectUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@",error);
        if(!error){
        for(int i=0;i<10;i++){
            [self.mapList addObject:[objects objectAtIndex:i]];
        }
    
        [self.table reloadData];
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
    
    AVObject *mapObject = [self.mapList objectAtIndex:indexPath.row];
    cell.nameLabel.text = [mapObject objectForKey:Title];
    AVUser *user = [mapObject objectForKey:Author];
    AVQuery *query =[AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:[user objectForKey:@"objectId"]];
    NSArray *uArray = [query findObjects];
    
    cell.authorLabel.text = [uArray[0] objectForKey:@"username"];
    cell.iconImage.layer.masksToBounds = YES;
    cell.iconImage.layer.cornerRadius =15;
    
    AVQuery *photoQuery = [AVQuery queryWithClassName:@"UserPhoto"];
   
    [photoQuery whereKey:@"user" equalTo:user];
    NSArray *pArray = [photoQuery findObjects];
    AVObject *photoObject = pArray[0];
    AVFile *theImage = [photoObject objectForKey:@"imageFile"];
    NSData *imageData = [theImage getData];
    cell.iconImage.image = [UIImage imageWithData:imageData];
    
    AVRelation *collectRelation = [mapObject objectForKey:CollectUser];
    NSArray *userCollectArray = [collectRelation.query findObjects];
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%d",userCollectArray.count];
    PFRelation *relation = [mapObject relationforKey:Place];
    NSArray *placeArray = [[relation query] findObjects];
    cell.placeCountLabel.text = [NSString stringWithFormat:@"%d",placeArray.count];
    
    NSArray * array = [MTPlace convertPlaceArray:placeArray];
    if(array.count!=0){
        
        CGRect placeRect = [MTPlace updateMemberPins:array];
        CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(placeRect.origin.x, placeRect.origin.y);
        
        //MTPlace *place = self.placeArray[0];
        int distance = placeRect.size.width;
        distance = MAX(1500,distance);
        distance = MIN(distance, 15000000);
        
        //MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(coodinate,distance,distance);
        
        NSString *markStr = @"/";
        for (MTPlace *place in array){
            NSString *str = [NSString stringWithFormat:@"pin-s+48C(%f,%f),",place.coordinate.longitude,place.coordinate.latitude];
            markStr = [markStr stringByAppendingString:str];
        }
        markStr = [markStr substringToIndex:([markStr length]-1)];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%f,%f,10/%.0fx%.0f.png",MapBoxPictureAPI,MapId,markStr,coodinate.longitude,coodinate.latitude,cell.mapImageView.frame.size.width,cell.mapImageView.frame.size.height];
        [cell.mapImageView setImageWithURL:[NSURL URLWithString:urlStr]];
        // [mapView setRegion:region animated:TRUE];
        //[mapView addAnnotations:array];
    }

    
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 185;
    
}

@end
