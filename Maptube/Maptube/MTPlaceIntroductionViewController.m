//
//  MTPlaceIntroductionViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-19.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTPlaceIntroductionViewController.h"
#import "MTChooseBoardViewController.h"
#import <Parse/Parse.h>
#import "MTPlace.h"

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

-(id)initWithData:(NSDictionary *)dict AndVenue:(FSVenue *)venue{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        
        
        //self.view.backgroundColor = [UIColor grayColor];
        UIStoryboard * storyBoard  = [UIStoryboard
                                      storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"PlaceIntroduction"];
        self.placeData = dict;
        self.venue = venue;
        
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled=NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.showsUserLocation=NO;
    
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(self.venue.coordinate,2000 ,2000 );
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:self.venue];
    
    
    self.boardArray = [NSMutableArray array];
	
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                
                PFRelation *placeRelation = [object relationforKey:Place];
                PFQuery *query = [placeRelation query];
                [query whereKey:VenueID containsString:self.venue.venueId];
                NSArray *array = [query findObjects];
                if(array.count!=0)
                [self.boardArray addObject:object];
            }
            
                [self.table reloadData];
                
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    self.titleLabel.text = [self.placeData objectForKey:@"name"];
    self.addressLabel.text = self.venue.location.address;
    //NSDictionary *categoryDict = [self.placeData objectForKey:@"catogories"];
    NSDictionary *pictureDict = [self.placeData objectForKey:@"photos"];
    NSArray *array = [pictureDict objectForKey:@"groups"];
    if(array.count!=0){
        pictureDict = [array objectAtIndex:0];
        NSArray *picArray = [pictureDict objectForKey:@"items"];
        
        NSDictionary *picDict = [picArray objectAtIndex:0];
        NSString *str= [picDict objectForKey:@"prefix"];
        str = [str stringByAppendingString:@"60x60"];
        str = [str stringByAppendingString:[picDict objectForKey:@"suffix"]];
            NSLog(@"%@",str);
        [self.iconImageView setImageWithURL:[NSURL URLWithString:str]];
    }
    
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }

    
}

-(IBAction)pin:(id)sender {
    
    MTChooseBoardViewController *controller = [[MTChooseBoardViewController alloc]initWithImage:self.iconImageView.image AndVenue:self.venue];
    controller.view.frame = CGRectMake(10, 100, self.view.frame.size.width-20, self.view.frame.size.height);
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.boardArray.count;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    PFObject *mapObject = [self.boardArray objectAtIndex:indexPath.row];
    cell.textLabel.text = mapObject[Title];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
