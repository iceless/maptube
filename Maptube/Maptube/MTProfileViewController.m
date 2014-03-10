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
    
    //recipes = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
   // PFUser *user = [PFUser currentUser];
    //NSMutableArray *boardArray = user[@"Board"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editProfile) name:ModifyProfileNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBoard) name:ModifyBoardNotification object:nil];
    self.placeArray = [NSMutableDictionary dictionary];

    [self updateBoard];
    
}
-(void)updateBoard{
    
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.boardArray = objects;
            
            
           for (int i=0;i<self.boardArray.count;i++) {
               
               PFObject *mapObject = [self.boardArray objectAtIndex:i];
               PFRelation *relation = [mapObject relationforKey:Place];
               [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
               
               [self.placeArray setObject:objects forKey:[NSString stringWithFormat:@"%d",i+1]];
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
    static NSString *cellIdentifier = @"errorCell";
    if (indexPath.row == 0) {
        cellIdentifier = @"ProfileCell";
    }
    else {
        cellIdentifier = @"MapCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    if (indexPath.row == 0) {
        
        NSString *name = [NSString stringWithFormat:NSLocalizedString(@"%@ %@", nil),
                          [PFUser currentUser][@"firstname"],
                          [PFUser currentUser][@"lastname"]];
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), name];
        
        UIImageView *imgv;
        imgv = (UIImageView *)[cell viewWithTag:4];
        imgv.image = [MTData sharedInstance].iconImage;
        imgv.layer.masksToBounds = YES;
        imgv.layer.cornerRadius = 40;
        
        
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser][@"location"]];
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser][@"description"]];
        
        for(int i=11;i<=14;i++){
            imgv = (UIImageView *)[cell viewWithTag:i];
            imgv.layer.borderWidth = 1;
            imgv.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
        }

        
        //label = (UILabel *)[cell viewWithTag:3];
        //label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser][@"description"]];
        
       
        
    }else {
        
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        
        PFObject *mapObject = [self.boardArray objectAtIndex:(indexPath.row-1)];
        label.text = [mapObject objectForKey:Title];
        
        label = (UILabel *)[cell viewWithTag:4];
        label.text = [mapObject objectForKey:Description];
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = [NSString stringWithFormat:@""];
        
       
        MKMapView *mapView = (MKMapView *)[cell viewWithTag:2];
        mapView.mapType = MKMapTypeStandard;
        mapView.zoomEnabled=NO;
        mapView.scrollEnabled = NO;
        mapView.showsUserLocation=NO;
        mapView.userInteractionEnabled = NO;
        mapView.layer.borderWidth =1.0;
       // mapView.layer.cornerRadius =5.0;
        mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
       // NSLog(@"%@",[MTParse sharedInstance].placeArray);

        NSArray *array = [self.placeArray objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        label = (UILabel *)[cell viewWithTag:5];
        label.text = [NSString stringWithFormat:@"%d places",array.count];
        array = [MTPlace convertPlaceArray:array];
        if(array.count!=0){
            CGRect placeRect = [MTPlace updateMemberPins:array];
            CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(placeRect.origin.x, placeRect.origin.y);
            
            //MTPlace *place = self.placeArray[0];
            int distance = placeRect.size.width;
            distance = MAX(1500,distance);
            
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
    static NSString *CellIdentifier;
    if (indexPath.row == 0)
        CellIdentifier = @"ProfileCell";
    else
        CellIdentifier = @"MapCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell.bounds.size.height;
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BoardDetail"]) {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        MTBoardViewController *destViewController = segue.destinationViewController;
        //PFObject *mapObject = [self.boardArray objectAtIndex:indexPath.row-1];
        NSArray *places = [self.placeArray objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        destViewController.boardData = [self.boardArray objectAtIndex:indexPath.row-1];
        if(places.count!=0){
            destViewController.placeArray = [MTPlace convertPlaceArray:places];
            destViewController.avPlaceArray = places;
            
        }
    }
    
   
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:ModifyBoardNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:ModifyProfileNotification];
}

@end
