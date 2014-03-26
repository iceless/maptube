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
    
    UIBarButtonItem *addMapItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addmap.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addMapBtnPressed:)];
    self.navigationItem.rightBarButtonItem = addMapItem;

    self.title = @"Profile";
    self.currentMap = 1;

    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.table.delegate =self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editProfile) name:ModifyProfileNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBoard) name:ModifyBoardNotification object:nil];
    self.placeArray = [NSMutableDictionary dictionary];
    
    self.locationManager =[[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=10.0f;
    [self.locationManager startUpdatingLocation];
    
    [self updateBoard];
    
}

-(void)initProfile {
    NSString *name = [NSString stringWithFormat:NSLocalizedString(@"%@ %@", nil),
                      [PFUser currentUser][@"firstname"],
                      [PFUser currentUser][@"lastname"]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(94,8,206,33)];
    label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), name];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(6,6,80,80)];
    imgv.image = [MTData sharedInstance].iconImage;
    imgv.layer.masksToBounds = YES;
    imgv.layer.cornerRadius = 40;
    [self.view addSubview:imgv];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(94,35,206,21)];
    label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser][@"location"]];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label];
    
    UITextView *descriptionView= [[UITextView alloc]initWithFrame:CGRectMake(88,53,302,29)];
    descriptionView.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser][@"description"]];
    descriptionView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:descriptionView];
    
    self.myMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.myMapButton.frame = CGRectMake(0, 89, 160, 47);
    [self.myMapButton setTitleColor:[UIColor blackColor]forState:UIControlStateSelected];
    [self.myMapButton setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [self.myMapButton setTitle:@"My Map" forState:UIControlStateNormal];
    [self.myMapButton addTarget:self action:@selector(clickMyMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myMapButton setSelected:YES];
    
    [self.view addSubview:self.myMapButton];
    
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionButton.frame = CGRectMake(161, 89, 160, 47);
    [self.collectionButton setTitleColor:[UIColor blackColor]forState:UIControlStateSelected];
    [self.collectionButton setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [self.collectionButton setTitle:@"Favorate" forState:UIControlStateNormal];
    [self.collectionButton addTarget:self action:@selector(clickFavorateButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.collectionButton];
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
    
    self.totalPlacesCount = [NSString stringWithFormat:@"%@",[[PFUser currentUser] objectForKey:@"PlacesCount"]];
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.boardArray = objects;
            
            
           for (int i=0;i<self.boardArray.count;i++) {
               
               PFObject *mapObject = [self.boardArray objectAtIndex:i];
               PFRelation *relation = [mapObject relationforKey:Place];
               [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                   if(objects.count!=0)
                    [self.placeArray setObject:objects forKey:[NSString stringWithFormat:@"%d",i+1]];
                    if(i==self.boardArray.count-1)
                    [self.table reloadData];
               }];
           }
             //[self.table reloadData];
            
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
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
- (void)viewWillAppear:(BOOL)animated {
    [self updateBoard];
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
//        self.nameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [[PFUser currentUser] username]];
        self.navItem.title = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [[PFUser currentUser] username]];
    } else {
//        self.nameLabel.text = NSLocalizedString(@"Not logged in", nil);
        self.navItem.title = @"nobody";
    }
    
    
}
-(void)editProfile{
    [self.table reloadData];
}
-(IBAction)clickAddCollection:(id)sender{
   // MTAddCollectionViewController *viewController = [[MTAddCollectionViewController alloc]init];
   // [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [recipes count];
   
    return self.boardArray.count+1;
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
        [cell.contentView addSubview:descriptionView];
        
        self.myMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.myMapButton.frame = CGRectMake(0, 89, 160, 47);
        [self.myMapButton setTitleColor:[UIColor blackColor]forState:UIControlStateSelected];
        [self.myMapButton setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
        [self.myMapButton setTitle:@"My Map" forState:UIControlStateNormal];
        [self.myMapButton addTarget:self action:@selector(clickMyMapButton:) forControlEvents:UIControlEventTouchUpInside];
        if(self.currentMap == 1)
        [self.myMapButton setSelected:YES];
        
        [cell.contentView addSubview:self.myMapButton];
        
        self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.collectionButton.frame = CGRectMake(161, 89, 160, 47);
        [self.collectionButton setTitleColor:[UIColor blackColor]forState:UIControlStateSelected];
        [self.collectionButton setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
        [self.collectionButton setTitle:@"Favorate" forState:UIControlStateNormal];
        [self.collectionButton addTarget:self action:@selector(clickFavorateButton:) forControlEvents:UIControlEventTouchUpInside];
        if(self.currentMap == 2)
            [self.collectionButton setSelected:YES];
        
        [cell.contentView addSubview:self.collectionButton];
        
        
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
        PFObject *mapObject = [self.boardArray objectAtIndex:(indexPath.row-1)];
        label.text = [mapObject objectForKey:Title];
        [cell.contentView addSubview:label];
        
       
        MKMapView *mapView = [[MKMapView alloc]initWithFrame:CGRectMake(9,30,304,119)];
        mapView.mapType = MKMapTypeStandard;
        mapView.zoomEnabled=NO;
        mapView.scrollEnabled = NO;
        mapView.showsUserLocation=NO;
        mapView.userInteractionEnabled = NO;
        mapView.layer.borderWidth =1.0;
        mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.contentView addSubview:mapView];


        NSArray *array = [self.placeArray objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        label = [[UILabel alloc]initWithFrame:CGRectMake(240,4,73,21)];
        label.text = [NSString stringWithFormat:@"%d places",array.count];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        array = [MTPlace convertPlaceArray:array];
        if(array.count!=0){
            CGRect placeRect = [MTPlace updateMemberPins:array];
            CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(placeRect.origin.x, placeRect.origin.y);
            
            //MTPlace *place = self.placeArray[0];
            int distance = placeRect.size.width;
            distance = MAX(1500,distance);
            distance = MIN(distance, 15000000);
            
            MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(coodinate,distance,distance);
            [mapView setRegion:region animated:TRUE];
            [mapView addAnnotations:array];
        }
         
        /*
        UIButton *button = (UIButton *)[cell viewWithTag:3];
        [button addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 9+indexPath.row;
         */
        
       
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
    if(indexPath.row != 0){
    MTBoardViewController *destViewController = [[MTBoardViewController alloc] init];
    //PFObject *mapObject = [self.boardArray objectAtIndex:indexPath.row-1];
    NSArray *places = [self.placeArray objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    destViewController.boardData = [self.boardArray objectAtIndex:indexPath.row-1];
    if(places.count!=0){
        destViewController.placeArray = [MTPlace convertPlaceArray:places];
        //destViewController.avPlaceArray = places;
        
    }
    [self.navigationController pushViewController:destViewController animated:YES];
    }
}

-(void)clickMyMapButton:(id)sender{
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    if(self.currentMap==2)
        [self.table reloadData];
    self.currentMap = 1;
    [self.collectionButton setSelected:NO];
    
}
-(void)clickFavorateButton:(id)sender{
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    if(self.currentMap==1)
        [self.table reloadData];
    self.currentMap = 2;
    [self.myMapButton setSelected:NO];
    
    
}

-(void)clickEdit:(id)sender{
    UIButton *button = (UIButton *)sender;
    int index = button.tag-10;
    PFObject *mapObject = [self.boardArray objectAtIndex:index];
    NSMutableArray *array = [NSMutableArray array];
    array[0] = [mapObject objectForKey:Title];
    array[1] = [mapObject objectForKey:Description];
    array[2] = [mapObject objectForKey:Category];
    array[3] = [mapObject objectForKey:Secret];
    
    MTEditBoardViewController *controller = [[MTEditBoardViewController alloc]initWithData:array andPFObject:mapObject];
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:ModifyBoardNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:ModifyProfileNotification];
}

@end
