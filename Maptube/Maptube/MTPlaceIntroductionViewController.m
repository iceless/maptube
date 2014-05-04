//
//  MTPlaceIntroductionViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-19.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTPlaceIntroductionViewController.h"
#import "MTMapViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MTPlace.h"
#import  "MTEditPlacePhotoViewController.h"
#import "MTPlaceImageViewController.h"
#import "MTMapDetailViewController.h"

@interface MTPlaceIntroductionViewController ()

@end

@implementation MTPlaceIntroductionViewController

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
    //self.tabBarController.tabBar.hidden = true;
    
    self.imageUrlArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeChooseBoardView) name:CloseChooseBoardNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEditPlacePhotoView) name:PopUpEditPlacePhotoNotification object:nil];
    self.boardArray = [NSMutableArray array];


    self.chooseBoardView = [[MTChooseBoardViewController alloc]initWithImage:nil AndVenue:self.venue];
    self.chooseBoardView.place = self.place;
    self.chooseBoardView.view.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
   
    UIView *greyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    greyView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    greyView.tag = 101;
    self.chooseBoardView.view.tag = 102;
    greyView.hidden = true;
    self.chooseBoardView.view.hidden = true;
    [[UIApplication sharedApplication].keyWindow addSubview:greyView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.chooseBoardView.view];
    
    
    
    //NSDictionary *categoryDict = [self.placeData objectForKey:@"catogories"];
    //add scroll view
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 180)];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.showsHorizontalScrollIndicator =NO;
    [self.view addSubview:self.scrollView];
    
    
   
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(5, 205, 310, 270) style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=CGRectMake(5, 30, 24, 24);
    [b addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [b setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:b];
    
  
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(220, 175, 36, 36);
   
   // if([self.map.author.objectId isEqualToString:[AVUser currentUser].objectId]){
   //     [button setTitle:@"Edit" forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(showEditPlacePhotoView) forControlEvents:UIControlEventTouchUpInside];
    //}
   // else {
    //    [button setTitle:@"Pin" forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(pin:) forControlEvents:UIControlEventTouchUpInside];
   // }
    [button setImage:[UIImage imageNamed:@"pin_active"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    if(self.venue){
        self.place = [[MTPlace alloc]initWithVenue:self.venue];
        
    }
    
    [self initData];

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    UISearchBar *searchbar = (UISearchBar *)[self.navigationController.view viewWithTag:1];
    searchbar.hidden = YES;
}



-(void)initData{
    
    NSArray *picArray;
    NSDictionary *pictureDict = [self.placeData objectForKey:@"photos"];
    NSArray *array = [pictureDict objectForKey:@"groups"];
    if(array.count!=0){
        pictureDict = [array objectAtIndex:0];
        picArray = [pictureDict objectForKey:@"items"];
        if(picArray.count!=0){
            for (int i=0; i<picArray.count; i++) {
                
                
                NSDictionary *picDict = [picArray objectAtIndex:i];
                NSString *str= [picDict objectForKey:@"prefix"];
                str = [str stringByAppendingString:@"300x300"];
                str = [str stringByAppendingString:[picDict objectForKey:@"suffix"]];
                //NSLog(@"%@",str);
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320,0, 320, 160)] ;
                [imgView setImageWithURL:[NSURL URLWithString:str]];
                [self.scrollView addSubview:imgView];
                [self.imageUrlArray addObject:str];
                
                
            }
            
        }
    }
    else if(self.place.placePhotos.count!=0){
        
            for (int i=0; i<self.place.placePhotos.count; i++)  {
                
                AVFile *picObject = self.place.placePhotos[i];
                NSData *imageData = [picObject getData];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320,0, 320, 160)] ;
                [imgView setImage:[UIImage imageWithData:imageData]];
                [self.scrollView addSubview:imgView];
                
                /*
                AVQuery *query =[AVQuery queryWithClassName:@"_File"];
                [query whereKey:@"objectId" equalTo:picObject.objectId];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    AVFile *file = objects[0];
                    NSData *imageData = [file getData];
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320,0, 320, 160)] ;
                    [imgView setImage:[UIImage imageWithData:imageData]];
                    [self.scrollView addSubview:imgView];

                }];
                */
                
            }
        picArray = self.place.placePhotos;
    }
    
        
    if(array.count!=0||self.place.placePhotos.count!=0){

        self.scrollView.contentSize = CGSizeMake(picArray.count*320, 160) ;
        self.scrollView.delegate = self;
        
        UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
        [self.scrollView addGestureRecognizer:sigleTapRecognizer];
        //[self.view addSubview:self.scrollView];
        //add pageControl
        
        self.pageControl = [[UIPageControl alloc] init];
        
        self.pageControl.frame = CGRectMake(150, 140, 20, 20);
        self.pageControl.numberOfPages = picArray.count;
        
        self.pageControl.currentPage = 0;
        [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:self.pageControl];
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 130, 30, 20)];
        numberLabel.text = [NSString stringWithFormat:@"%d",picArray.count];
        numberLabel.textColor = [UIColor blueColor];
        [self.view addSubview:numberLabel];
    }
    self.chooseBoardView.imageUrlArray = self.imageUrlArray;
    self.chooseBoardView.map = self.map;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 170, 160, 40)];
    if(self.venue)
    titleLabel.text = self.venue.name;
    else titleLabel.text = self.place.title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:titleLabel];
    [self.table reloadData];
    
}


-(void)showMap{
    MTMapViewController *viewController = [[MTMapViewController alloc]init];
    viewController.venue = self.venue;
    viewController.place = self.place;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    int page = self.scrollView.contentOffset.x / 310;
    self.pageControl.currentPage = page;
    
}

- (IBAction)changePage:(id)sender {
    
    int page = self.pageControl.currentPage;
    
    [self.scrollView setContentOffset:CGPointMake(320 * page, 0)];
    
}

-(void)clickImage:(id)sender{
    MTPlaceImageViewController *controller = [[MTPlaceImageViewController alloc]init];
    controller.imageUrlArray = self.imageUrlArray;
    controller.avFileImageArray = self.place.placePhotos;
    [self.navigationController pushViewController:controller animated:YES];
    
}


-(void)updateBoard{
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                
                PFRelation *placeRelation = [object relationforKey:Place];
                PFQuery *query = [placeRelation query];
                [query whereKey:VenueID containsString:self.venue.venueId];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if(objects.count!=0){
                        [self.boardArray addObject:object];
                        [self.table reloadData];
                    }
                    
                }];
            }
            
            [self.table reloadData];
            
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
}

-(void)closeChooseBoardView{
    UIView *view = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:101];
    view.hidden = true;
    view = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:102];
    view.hidden = true;
}

-(void)showEditPlacePhotoView{
    MTEditPlacePhotoViewController *viewController = [[MTEditPlacePhotoViewController alloc]init];
    viewController.imageStrArray = self.imageUrlArray;
    //viewController.placeName = self.venue.name;
    if(self.venue)
    viewController.location = self.venue.location.address;
    else viewController.location = self.place.venueAddress;
    viewController.place = self.place;
    [self.navigationController pushViewController:viewController animated:NO];
}

-(IBAction)pin:(id)sender {
    //to do
    //MTChooseBoardViewController *controller = [[MTChooseBoardViewController alloc]initWithImage:self.iconImageView.image AndVenue:self.venue];
    
    UIView *view = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:101];
    view.hidden = false;
    view = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:102];
    view.hidden = false;
    
    //[self.navigationController pushViewController:controller animated:YES];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
       
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if(indexPath.section==0){
        if(indexPath.row==0) {
            CLLocationCoordinate2D coordinate;
            if(self.venue) coordinate = self.venue.coordinate;
            else coordinate = CLLocationCoordinate2DMake(self.place.latitude.doubleValue, self.place.longitude.doubleValue);
            NSString *markStr = @"/";
            NSString *str = [NSString stringWithFormat:@"pin-s+48C(%f,%f)",coordinate.longitude,coordinate.latitude];
            markStr = [markStr stringByAppendingString:str];
            UIImageView *mapImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%f,%f,10/%.0fx%.0f.png",MapBoxAPI,MapId,markStr,coordinate.longitude,coordinate.latitude,mapImgView.frame.size.width,mapImgView.frame.size.height];
            [mapImgView setImageWithURL:[NSURL URLWithString:urlStr]];
            mapImgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMap)];
            [mapImgView addGestureRecognizer:singleTapRecognizer];
            [cell.contentView addSubview:mapImgView];
            
        }
        else{
            cell.textLabel.text = self.venue.location.address;
        
        }
        
    }
    else{
        if(indexPath.row==0) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
            [cell.contentView addSubview:imgView];
            imgView.image = self.map.authorImage;
            imgView.layer.masksToBounds = YES;
            imgView.layer.cornerRadius =15;
            [cell.contentView addSubview:imgView];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 70, 20)];
            label.text = @"Pinned by";
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [UIColor lightGrayColor];
            label = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 100, 20)];
            label.text = [self.map.author objectForKey:@"username"];
            [cell.contentView addSubview:label];
        }
        else{
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 70, 20)];
            label.text = @"Pinned in";
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [UIColor lightGrayColor];
            label = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 100, 20)];
            label.text = [self.map.mapObject objectForKey:Title];
            [cell.contentView addSubview:label];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        if(indexPath.row==0)
        return 120;
        else return 30;
    }
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.map){
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1&&indexPath.row!=0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MTMapDetailViewController *controller = [[MTMapDetailViewController alloc]init];
        controller.mapData = self.map;
        controller.placeArray = self.mapPlaceArray;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    UIView *greyView = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:101];
    [[NSNotificationCenter defaultCenter] removeObserver:CloseChooseBoardNotification];
    [self.chooseBoardView.view removeFromSuperview];
    [greyView removeFromSuperview];
}

@end
