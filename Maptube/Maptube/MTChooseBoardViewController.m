//
//  MTChooseBoardViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-18.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTChooseBoardViewController.h"
#import <Parse/Parse.h>
#import "MTAddCollectionViewController.h"


@interface MTChooseBoardViewController ()

@end

@implementation MTChooseBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithImage:(UIImage *)image AndVenue:(FSVenue *)venue{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        UIStoryboard * storyBoard  = [UIStoryboard
                                      storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"ChooseBoard"];
        self.venue = venue;
        self.image = image;
    }
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //PFUser *user = [PFUser currentUser];
   // self.boardArray = user[@"Board"];
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    
    self.boardArray = [[relation query] findObjects];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 50, 32);
    [button addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=barItem;
    
    button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 100, 32);
    [button addTarget:self action:@selector(createBoard) forControlEvents:UIControlEventTouchUpInside];
    barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"CreateBoard" forState:UIControlStateNormal];
    //[button setBackgroundColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem=barItem;
    
    
    //self.table.frame = CGRectMake(10, 100, self.view.frame.size.width-20, self.view.frame.size.height);
    
    
    
    
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [self.table reloadData];
    
}
-(void)navBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createBoard{
    MTAddCollectionViewController *controller = [[MTAddCollectionViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0) return 1;
    else return self.boardArray.count;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==1)
        return @"ALL BOARDS";
    else return nil;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    static NSString *cellIdentifier = @"PlaceCell";
    if(indexPath.section==0){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
        imgView.image = self.image;
        self.describeTextField = (UITextField *)[cell viewWithTag:2];
        UILabel *placeTitle = (UILabel *)[cell viewWithTag:3];
        placeTitle.text = self.venue.name;
        
    }
    else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        PFObject *mapObject = [self.boardArray objectAtIndex:indexPath.row];
        cell.textLabel.text = mapObject[Title];
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if(self.describeTextField.text.length==0){
         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please fill the describe first", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
     */
   // NSLog(@"%@",self.boardArray);
    PFObject *mapObject = [self.boardArray objectAtIndex:indexPath.row];
    
    PFObject *placeObject = [PFObject objectWithClassName:Place];
    [placeObject setObject:self.venue.title forKey:Title];
    if(self.describeTextField.text.length!=0){
          [placeObject setObject:self.describeTextField.text  forKey:Description];
    }
    [placeObject setObject:self.venue.venueId forKey:VenueID];
    [placeObject setObject:self.venue.location.address forKey:VenueAddress];
    NSNumber *number = [NSNumber numberWithDouble:self.venue.location.coordinate.longitude];
    [placeObject setObject:number forKey:Longitude];
    number = [NSNumber numberWithDouble:self.venue.location.coordinate.latitude];
    [placeObject setObject:number forKey:Latitude];
    [placeObject saveEventually: ^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFRelation *relation = [mapObject relationforKey:Place];
            [relation addObject:placeObject];
            [mapObject saveEventually: ^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:ModifyBoardNotification object:nil];
            }
                  }];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    

//[venueDict setObject:self.venue.location.distance forKey:@"Distance"];
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return 86;
    else return 40;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
