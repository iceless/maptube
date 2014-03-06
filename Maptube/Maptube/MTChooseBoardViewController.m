//
//  MTChooseBoardViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-18.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTChooseBoardViewController.h"
#import <AVOSCloud/AVOSCloud.h>
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
    self.boardArray = [[NSMutableArray alloc]init];
    //PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    [self updateBoard];
    //self.boardArray = [[relation query] findObjects];
    UINavigationItem *navigationItem =[[UINavigationItem alloc] initWithTitle:self.venue.name];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 50, 32);
    [button addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    navigationItem.leftBarButtonItem=barItem;
    
    button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 100, 32);
    [button addTarget:self action:@selector(addPlace) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    //[button setBackgroundColor:[UIColor redColor]];
    navigationItem.rightBarButtonItem=barItem;
   
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bar pushNavigationItem:navigationItem animated:YES];
    
    [self.view addSubview:bar];
    
    
    //self.table.frame = CGRectMake(10, 100, self.view.frame.size.width-20, self.view.frame.size.height);
    
    
    
    
	// Do any additional setup after loading the view.
}
-(void)updateBoard{
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    
    NSArray *mapArray = [[relation query] findObjects];
    for(PFObject *object in mapArray){
        PFRelation *placeRelation = [object relationforKey:Place];
        PFQuery *query = [placeRelation query];
        [query whereKey:VenueID containsString:self.venue.venueId];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSDictionary *dict;
            if(objects.count!=0){
                dict =@{@"object": object,@"exsist": @"1"};
                
            }
            else{
                dict =@{@"object": object,@"exsist": @"0"};
                
            }
            [self.boardArray addObject:dict];
            [self.table reloadData];
        }];
        
        
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [self updateBoard];
}
-(void)navBack{
    //[self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:CloseChooseBoardNotification object:nil];
}
-(void)createBoard{
    MTAddCollectionViewController *controller = [[MTAddCollectionViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)addPlace{
   
    
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:VenueID containsString:self.venue.venueId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count!=0){
            PFObject * placeObject = (PFObject *)objects[0];
             [self addPlaceRelation:placeObject];
        }
        else{
            
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
            [placeObject setObject:self.venue.location.distance forKey:Distance];
            [placeObject saveEventually: ^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    [self addPlaceRelation:placeObject];
                    
                }
            }];
    
    }
        
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:CloseChooseBoardNotification object:Nil];
}

-(void)addPlaceRelation:(PFObject *)placeObject{
    
    for(NSDictionary *dict in self.boardArray){
        if([[dict objectForKey:@"exsist"] isEqualToString:@"1"]){
            PFObject *mapObject = [dict objectForKey:@"object"];
            PFRelation *relation = [mapObject relationforKey:Place];
            
            [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject *object in objects) {
                    if([object[VenueID] isEqualToString:self.venue.venueId]){
                        
                        continue;
                        
                    }
                }
                PFRelation *relation = [mapObject relationforKey:Place];
                [relation addObject:placeObject];
                [mapObject saveEventually: ^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        
                        
                    }
                }];
                
                
            }];
        }
        
    }
    
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
        NSDictionary *dict = [self.boardArray objectAtIndex:indexPath.row];

        PFObject *mapObject = [dict objectForKey:@"object"];
        NSString *str = [dict objectForKey:@"exsist"];
        if([str isEqualToString:@"1"]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        cell.textLabel.text = mapObject[Title];
        
    }
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dict = [[self.boardArray objectAtIndex:indexPath.row] mutableCopy];
  
    
    if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
        [dict setObject:@"0" forKey:@"exsist"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    else {
       
        [dict setObject:@"1" forKey:@"exsist"];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    [self.boardArray replaceObjectAtIndex:indexPath.row withObject:dict];
    /*
  
    PFObject *mapObject = [self.boardArray objectAtIndex:indexPath.row];
    
    PFRelation *relation = [mapObject relationforKey:Place];
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            if([object[VenueID] isEqualToString:self.venue.venueId]){
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"The place exsits in the Map", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                return ;
                
            }
        }
        PFQuery *query = [PFQuery queryWithClassName:@"Place"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *object in objects) {
                if([object[VenueID] isEqualToString:self.venue.venueId]){
                    PFRelation *relation = [mapObject relationforKey:Place];
                    [relation addObject:object];
                    [mapObject saveEventually: ^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:ModifyBoardNotification object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];

                    return ;
                    
            }
            }
        
        
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
        [placeObject setObject:self.venue.location.distance forKey:Distance];
        [placeObject saveEventually: ^(BOOL succeeded, NSError *error) {
            if (!error) {
                PFRelation *relation = [mapObject relationforKey:Place];
                [relation addObject:placeObject];
                [mapObject saveEventually: ^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:ModifyBoardNotification object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

        
        }];
         }
     
     ];
           
    */
    
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
