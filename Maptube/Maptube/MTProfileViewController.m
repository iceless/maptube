//
//  MTProfileViewController.m
//  Maptube
//
//  Created by Bing W on 12/24/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import <MapKit/MapKit.h>
#import "MTProfileViewController.h"
#import "MTAddCollectionViewController.h"
#import "MTBoardViewController.h"
#import "FSConverter.h"
#import "MTPlace.h"
#import "MTEditBoardViewController.h"
#import "MTSettingsViewController.h"
#import "MTEditProfileViewController.h"
#import "MTMap.h"
#import "MTMapDetailViewController.h"

@interface MTProfileViewController ()

@end

@implementation MTProfileViewController{
    NSArray *recipes;
}

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
    

    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingBtnPressed:)];
    
    self.navigationItem.leftBarButtonItem = settingItem;
    
    UIBarButtonItem *addMapItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"create_a_map.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addMapBtnPressed:)];
    //addMapItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addMapItem;

    //self.title = @"Profile";
    self.currentMap = 1;

    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.table.delegate =self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:ModifyProfileNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBoard) name:ModifyBoardNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:RefreshTableViewNotification object:nil];
    self.myMapArray = [NSMutableArray array];
    self.favorateMapArray = [NSMutableArray array];
    
    self.locationManager =[[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=10.0f;
    [self.locationManager startUpdatingLocation];
    [self performSelectorInBackground:@selector(updateBoard) withObject:nil];

    
    
}

- (void)viewWillAppear:(BOOL)animated {
    // [self updateBoard];
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        
        self.navItem.title = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [[PFUser currentUser] username]];
    } else {
        
        self.navItem.title = @"nobody";
    }
   
    
    
}

-(void)refreshTableView{
    [self.table reloadData];
}


- (void)settingBtnPressed:(id)sender
{
    MTSettingsViewController *targetVC = [[MTSettingsViewController alloc] init];
    [self.navigationController pushViewController:targetVC animated:YES];
}

- (void)addMapBtnPressed:(id)sender
{
    MTAddCollectionViewController *targetVC = [[MTAddCollectionViewController alloc] init];
    [self.navigationController pushViewController:targetVC animated:YES];
}

-(void)updateBoard{
    
    [self.myMapArray removeAllObjects];
    [self.favorateMapArray removeAllObjects];
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
     [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         
        for (int i=0;i<objects.count;i++) {
            MTMap *map = [[MTMap alloc]init];
            map.mapObject = objects[i];
            [map initData];
            [self.myMapArray addObject:map];
            if(i==self.myMapArray.count-1)
            [self.table reloadData];
        
        }
    }];
    
    PFRelation *favorateMapRelation = [[PFUser currentUser] relationforKey:CollectMap];
     [[favorateMapRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         
         for (int i=0;i<objects.count;i++) {
             MTMap *map = [[MTMap alloc]init];
             map.mapObject = objects[i];
             [map initData];
             [self.favorateMapArray addObject:map];
             if(i==self.favorateMapArray.count-1)
                 [self.table reloadData];
             
         }
         
     }];
    
}


#pragma mark - Location Delegation
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation
{
    [MTData sharedInstance].curCoordinate = newLocation.coordinate;
    [self.locationManager stopUpdatingLocation];
    
    
}





/*
- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    
    
    //        [self dismissViewControllerAnimated:YES completion:NULL];
    //    [self presentViewController:logInViewController animated:YES completion:NULL];
    //    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
*/
#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [recipes count];
    if(self.currentMap==1)
        return self.myMapArray.count+1;
    else
        return self.favorateMapArray.count+1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row == 0) {
        
        NSString *name = [NSString stringWithFormat:NSLocalizedString(@"%@ %@", nil),
                          [PFUser currentUser][@"firstname"],
                          [PFUser currentUser][@"lastname"]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(94,8,206,33)];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), name];
        label.font = [UIFont systemFontOfSize:20];
        [cell.contentView addSubview:label];
        
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(6,6,80,80)];
        imgv.image = [MTData sharedInstance].iconImage;
        imgv.layer.masksToBounds = YES;
        imgv.layer.cornerRadius = 40;
        [cell.contentView addSubview:imgv];
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(94,35,206,21)];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser][@"location"]];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:label];
        
        UITextView *descriptionView= [[UITextView alloc]initWithFrame:CGRectMake(88,53,302,29)];
        descriptionView.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser][@"description"]];
        descriptionView.font = [UIFont systemFontOfSize:13];
        descriptionView.delegate = self;
        [cell.contentView addSubview:descriptionView];
        
        self.myMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.myMapButton.frame = CGRectMake(0, 89, 160, 47);
        [self.myMapButton setBackgroundImage:[MTData createImageWithColor:[UIColor colorWithWhite:0.9 alpha:0.9]] forState:UIControlStateSelected];
        [self.myMapButton setImage:[UIImage imageNamed: @"profile_mymap"]  forState:UIControlStateNormal];
        [self.myMapButton addTarget:self action:@selector(clickMyMapButton:) forControlEvents:UIControlEventTouchUpInside];
        if(self.currentMap == 1)
        [self.myMapButton setSelected:YES];
        self.myMapButton.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.9].CGColor;
        self.myMapButton.layer.borderWidth = 1;
        
        
        [cell.contentView addSubview:self.myMapButton];
        
        self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.collectionButton.frame = CGRectMake(160, 89, 160, 47);
        [self.collectionButton setBackgroundImage:[MTData createImageWithColor:[UIColor colorWithWhite:0.9 alpha:0.9]] forState:UIControlStateSelected];
        
        [self.collectionButton setImage:[UIImage imageNamed: @"profile_favorites"] forState:UIControlStateNormal];
        [self.collectionButton addTarget:self action:@selector(clickFavorateButton:) forControlEvents:UIControlEventTouchUpInside];
        if(self.currentMap == 2)
            [self.collectionButton setSelected:YES];
        self.collectionButton.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.9].CGColor;
        self.collectionButton.layer.borderWidth = 1;
        
        [cell.contentView addSubview:self.collectionButton];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
        
        /*
        imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0,89,81,47)];
        imgv.layer.borderWidth = 1;
        imgv.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.contentView addSubview:imgv];
        imgv = [[UIImageView alloc]initWithFrame:CGRectMake(80,89,81,47)];
        imgv.layer.borderWidth = 1;
        imgv.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.contentView addSubview:imgv];
        imgv = [[UIImageView alloc]initWithFrame:CGRectMake(160,89,81,47)];
        imgv.layer.borderWidth = 1;
        imgv.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.contentView addSubview:imgv];
        imgv = [[UIImageView alloc]initWithFrame:CGRectMake(240,89,80,47)];
        imgv.layer.borderWidth = 1;
        imgv.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.contentView addSubview:imgv];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(20,115,46,21)];
        label.text = @"Places";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0,95,81,21)];
        label.text = self.totalPlacesCount;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(103,115,36,21)];
        label.text = @"Likes";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        label = [[UILabel alloc]initWithFrame:CGRectMake(169,115,64,21)];
        label.text = @"Followers";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        label = [[UILabel alloc]initWithFrame:CGRectMake(251,115,64,21)];
        label.text = @"Following";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        */
    }else {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(9,4,203,21)];
        MTMap *map;
        if(self.currentMap==1)
            map= [self.myMapArray objectAtIndex:(indexPath.row-1)];
        else map= [self.favorateMapArray objectAtIndex:(indexPath.row-1)];
        
        label.text = [map.mapObject objectForKey:Title];
        [cell.contentView addSubview:label];
        
       /*
        MKMapView *mapView = [[MKMapView alloc]initWithFrame:CGRectMake(9,30,304,119)];
        mapView.mapType = MKMapTypeStandard;
        mapView.zoomEnabled=NO;
        mapView.scrollEnabled = NO;
        mapView.showsUserLocation=NO;
        mapView.userInteractionEnabled = NO;
        mapView.layer.borderWidth =1.0;
        mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.contentView addSubview:mapView];
       */
        UIImageView *mapImgView = [[UIImageView alloc]initWithFrame:CGRectMake(9,30,304,119)];
        [cell.contentView addSubview:mapImgView];
        
        
       
        label = [[UILabel alloc]initWithFrame:CGRectMake(235,4,73,21)];
        label.text = [NSString stringWithFormat:@"%d",map.placeArray.count];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mappin"]];
        imgView.frame = CGRectMake(220,4,18,18);
        [cell.contentView addSubview:imgView];
        
       
       
        label = [[UILabel alloc]initWithFrame:CGRectMake(280,4,73,21)];
        label.text = [NSString stringWithFormat:@"%d",map.collectUsers.count];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like"]];
        imgView.frame = CGRectMake(260,4,18,18);
        [cell.contentView addSubview:imgView];
        
        NSArray *array;
    
        array = map.placeArray;
        if(array.count!=0){
            
            CGRect placeRect = [MTPlace updateMemberPins:array];
            CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(placeRect.origin.x, placeRect.origin.y);
            
            //MTPlace *place = self.myPlaceArray[0];
            int distance = placeRect.size.width;
            distance = MAX(1500,distance);
            distance = MIN(distance, 15000000);
            
            //MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(coodinate,distance,distance);
          
            NSString *markStr = @"/";
            for (MTPlace *place in array){
                NSString *str = [NSString stringWithFormat:@"pin-s+48C(%f,%f),",place.longitude.doubleValue,place.latitude.doubleValue];
                markStr = [markStr stringByAppendingString:str];
            }
            markStr = [markStr substringToIndex:([markStr length]-1)];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%f,%f,10/%.0fx%.0f.png",MapBoxAPI,MapId,markStr,coodinate.longitude,coodinate.latitude,mapImgView.frame.size.width,mapImgView.frame.size.height];
            [mapImgView setImageWithURL:[NSURL URLWithString:urlStr]];
        
        }
        
        else{
            //mapImgView放置默认图片
        }
         
       
        
       
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* In this example, there is a different cell for
     the top, middle and bottom rows of the tableView.
     Each type of cell has a different height.
     self.model contains the data for the tableview
     */
    
    if (indexPath.row == 0)
        return 146;
    else
        return 158;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row != 0){
        MTMapDetailViewController *destViewController = [[MTMapDetailViewController alloc] init];
        
        NSArray *places;
        if(self.currentMap ==1){
            MTMap *map = [self.myMapArray objectAtIndex:indexPath.row-1];
            places = map.placeArray;
            destViewController.mapData = map;
        }
        else {
            MTMap *map = [self.favorateMapArray objectAtIndex:indexPath.row-1];

            places = map.placeArray;

            destViewController.mapData = map;
        }
        
        if(places.count!=0){
            //destViewController.placeArray = [MTPlace convertPlaceArray:places];
            destViewController.placeArray = places;
            
        }
        destViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:destViewController animated:YES];
    }
    else{
        MTEditProfileViewController  *controller = [[MTEditProfileViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - TextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView{
    AVUser *user = [AVUser currentUser];
    user[@"description"] = textView.text;
    [user saveEventually];
    [textView resignFirstResponder];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - Action

-(void)clickMyMapButton:(id)sender{
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    if(self.currentMap==2){
         self.currentMap = 1;
        [self.table reloadData];
    }
    self.currentMap = 1;
    [self.collectionButton setSelected:NO];
    
}
-(void)clickFavorateButton:(id)sender{
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    if(self.currentMap==1){
          self.currentMap = 2;
        [self.table reloadData];
    }
  
    [self.myMapButton setSelected:NO];
    
    
}

-(void)clickEdit:(id)sender{
    UIButton *button = (UIButton *)sender;
    int index = button.tag-10;
    PFObject *mapObject = [self.myMapArray objectAtIndex:index];
    NSMutableArray *array = [NSMutableArray array];
    array[0] = [mapObject objectForKey:Title];
    array[1] = [mapObject objectForKey:Description];
    array[2] = [mapObject objectForKey:Category];
    array[3] = [mapObject objectForKey:Secret];
    
    MTEditBoardViewController *controller = [[MTEditBoardViewController alloc]initWithData:array andPFObject:mapObject];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:ModifyBoardNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:ModifyProfileNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:RefreshTableViewNotification];
}

@end
