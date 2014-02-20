//
//  MTProfileViewController.m
//  Maptube
//
//  Created by Bing W on 12/24/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <Parse/Parse.h>
#import "MTProfileViewController.h"
#import "MTAddCollectionViewController.h"
#import "MTBoardViewController.h"
#import "FSConverter.h"

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
    
    recipes = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    PFUser *user = [PFUser currentUser];
    NSMutableArray *boardArray = user[@"Board"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editProfile) name:ModifyProfileNotification object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
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
    NSArray *array= [PFUser currentUser][@"Board"];
    return array.count+1;
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
    PFUser *user = [PFUser currentUser];
    NSMutableArray *boardArray = user[@"Board"];
    NSLog(@"%@",boardArray);
    
    if (indexPath.row == 0) {
        
        NSString *name = [NSString stringWithFormat:NSLocalizedString(@"%@ %@", nil),
                          [PFUser currentUser][@"firstname"],
                          [PFUser currentUser][@"lastname"]];
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), name];
        
        UIImageView *imgv;
        imgv = (UIImageView *)[cell viewWithTag:4];
        imgv.image = [UIImage imageNamed:@"profilepic.JPG"];
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser][@"location"]];
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser][@"description"]];
        
    }else {
        
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        
        NSArray *array = [boardArray objectAtIndex:(indexPath.row-1)];
        label.text = array[0];
       
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:2];
        imgView.image = [UIImage imageNamed:@"board"];
        
       
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
if ([segue.identifier isEqualToString:@"BoardDetail"]) {
    NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
    MTBoardViewController *destViewController = segue.destinationViewController;
    NSArray *array = [PFUser currentUser][@"Board"][indexPath.row-1];
    if(array.count==6){
    NSArray *venuArray = [PFUser currentUser][@"Board"][indexPath.row-1][5];
    destViewController.placeArray = [FSConverter objectsConvertToVenues:venuArray];
    }
}
}


@end
