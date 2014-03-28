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
   
    //self.boardArray = [[relation query] findObjects];
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 568)];
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    UINavigationItem *navigationItem =[[UINavigationItem alloc] initWithTitle:@"Pick a Map"];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 40, 32);
    [button addTarget:self action:@selector(createBoard) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"addmap"] forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    navigationItem.rightBarButtonItem=barItem;
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(navBack)];
   
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bar pushNavigationItem:navigationItem animated:YES];
    [self.view addSubview:bar];
    [MTViewHelper setExtraCellLineHidden:self.table];
     [self updateBoard];
	// Do any additional setup after loading the view.
}

-(void)updateBoard {
    /*
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    [self.boardArray removeAllObjects];
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
*/
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    self.boardArray = [[relation query] findObjects];
    [self.table reloadData];
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
                    NSNumber *number = [[AVUser currentUser] objectForKey:@"PlacesCount"];
                    int count = number.integerValue;
                    count++;
                    [[AVUser currentUser] setObject:[NSNumber numberWithInteger:count] forKey:@"PlacesCount"];
                    [[AVUser currentUser] saveEventually];
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
                BOOL exsistPlace = false;
                for (PFObject *object in objects) {
                    if([object[VenueID] isEqualToString:self.venue.venueId]){
                        exsistPlace = true;
                        break;
                    }
                    
                }
                if(!exsistPlace){
                PFRelation *relation = [mapObject relationforKey:Place];
                [relation addObject:placeObject];
                [mapObject saveInBackground];
                }
            }];
        }
        
        else{
            PFObject *mapObject = [dict objectForKey:@"object"];
            PFRelation *relation = [mapObject relationforKey:Place];
            [relation removeObject:placeObject];
            [mapObject saveInBackground];
            
        }
        
    }
    
}
/*
-(void)addBoard:(NSString *)str{
    
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *mapObject in objects){
            if([mapObject[Title] isEqualToString:str])
            {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"The same map name exsits,please change the title", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                return ;
                
                
            }
            
        }
        PFObject *mapObject = [PFObject objectWithClassName:Map];
        [mapObject setObject:str forKey:Title];
        
        [mapObject saveEventually: ^(BOOL succeeded, NSError *error) {
            if (!error) {
                PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
                [relation addObject:mapObject];
                
                [[PFUser currentUser] saveEventually: ^(BOOL succeeded, NSError *error) {
                    if(succeeded){
                        NSDictionary *dict=@{@"object": mapObject,@"exsist": @"0"};
                        [self.boardArray addObject:dict];
                        [self.table reloadData];
                    }
                }];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        
    }];

    
}

*/

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0) return 1;
    else return self.boardArray.count;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    //static NSString *cellIdentifier = @"NewMapCell";
    
    if(indexPath.section==0){
       //cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.textLabel.text = self.venue.name;
        
    }
    else{
     

        PFObject *mapObject = [self.boardArray objectAtIndex:indexPath.row];

        
        cell.textLabel.text = mapObject[Title];
        
    }
   
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==1) {
        return @"My Maps";
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        [[NSNotificationCenter defaultCenter] postNotificationName:CloseChooseBoardNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:PopUpEditPlacePhotoNotification object:nil];
        return;
        
    }
    /*
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
    */
   // [self.boardArray replaceObjectAtIndex:indexPath.row withObject:dict];
    
  
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
        //[placeObject setObject:self.venue.location.distance forKey:Distance];
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
           
    
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if(indexPath.section==0)
      //  return 40;
    //else
        return 40;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
