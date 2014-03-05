//
//  MTPlaceIntroductionViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-19.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTPlaceIntroductionViewController.h"

#import <AVOSCloud/AVOSCloud.h>
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
    self.tabBarController.tabBar.hidden = true;
    /*
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled=NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.showsUserLocation=NO;
    
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(self.venue.coordinate,2000 ,2000 );
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:self.venue];
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBoard) name:ModifyBoardNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeChooseBoardView) name:CloseChooseBoardNotification object:nil];
    
    
    self.boardArray = [NSMutableArray array];
	[self updateBoard];
    self.title = [self.placeData objectForKey:@"name"];

    
    self.addressLabel.text = self.venue.location.address;
    self.mapButton.layer.borderWidth = 1.0;
    self.mapButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1];
    imageView.layer.borderWidth = 1.0;
    imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    //NSDictionary *categoryDict = [self.placeData objectForKey:@"catogories"];
    //add scroll view
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+10, 320, 120)];
    }
    else {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
        
    }
    
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.showsHorizontalScrollIndicator =YES;
    NSDictionary *pictureDict = [self.placeData objectForKey:@"photos"];
    NSArray *array = [pictureDict objectForKey:@"groups"];
    if(array.count!=0){
    pictureDict = [array objectAtIndex:0];
    NSArray *picArray = [pictureDict objectForKey:@"items"];
    if(picArray.count!=0){
        for (int i=0; i<picArray.count; i++) {
            
            
            NSDictionary *picDict = [picArray objectAtIndex:i];
            NSString *str= [picDict objectForKey:@"prefix"];
            str = [str stringByAppendingString:@"120x120"];
            str = [str stringByAppendingString:[picDict objectForKey:@"suffix"]];
            //NSLog(@"%@",str);
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320+40,0, 240, 120)] ;
            [imgView setImageWithURL:[NSURL URLWithString:str]];
            [self.scrollView addSubview:imgView];
        }
       
    }
    
        self.scrollView.contentSize = CGSizeMake(picArray.count*320, 140) ;
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
        //add pageControl
        
        self.pageControl = [[UIPageControl alloc] init];
        
        self.pageControl.frame = CGRectMake(150, 150, 20, 20);
        self.pageControl.numberOfPages = picArray.count;
        
        self.pageControl.currentPage = 0;
        [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        
        
        
        
        [self.view addSubview:self.pageControl];
    }
    
    
    
    
    
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    self.chooseBoardView = [[MTChooseBoardViewController alloc]initWithImage:nil AndVenue:self.venue];
    self.chooseBoardView.view.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
    UIView *greyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    greyView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    greyView.tag = 101;
    self.chooseBoardView.view.tag = 102;
    greyView.hidden = true;
    self.chooseBoardView.view.hidden = true;
    [self.view addSubview:greyView];
    [self.view addSubview:self.chooseBoardView.view];

    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    int page = self.scrollView.contentOffset.x / 310;
    self.pageControl.currentPage = page;
    
}

- (IBAction)changePage:(id)sender {
    
    int page = self.pageControl.currentPage;
    
    [self.scrollView setContentOffset:CGPointMake(320 * page, 0)];
    
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
    UIView *view = (UIView *)[self.view viewWithTag:101];
    view.hidden = true;
    view = (UIView *)[self.view viewWithTag:102];
    view.hidden = true;
}

-(IBAction)pin:(id)sender {
    //to do
    //MTChooseBoardViewController *controller = [[MTChooseBoardViewController alloc]initWithImage:self.iconImageView.image AndVenue:self.venue];
    
    UIView *view = (UIView *)[self.view viewWithTag:101];
    view.hidden = false;
    view = (UIView *)[self.view viewWithTag:102];
    view.hidden = false;
    
    //[self.navigationController pushViewController:controller animated:YES];
    
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
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    
    
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
-(void)dealloc{
   
    [[NSNotificationCenter defaultCenter] removeObserver:ModifyProfileNotification];
}

@end
