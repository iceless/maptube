//
//  MTBoardViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-17.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTBoardViewController.h"
#import "FSVenue.h"

@interface MTBoardViewController ()

@end

@implementation MTBoardViewController

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
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled=YES;
    self.mapView.showsUserLocation=NO;
    self.mapView.delegate=self;
    self.tableView.backgroundColor = [UIColor clearColor];
    NSLog(@"%@",self.placeArray);
    if(self.placeArray.count!=0){
        FSVenue *venue = self.placeArray[0];
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(venue.coordinate,2000 ,2000 );
        [self.mapView setRegion:region animated:TRUE];
        [self.mapView addAnnotations:self.placeArray];
    }
    
    

}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.mapView.frame.size.height-40, 0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < self.mapView.frame.size.height*-1 ) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, self.mapView.frame.size.height*-1)];
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}
-(void) touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
	//CGPoint pt = [[touches anyObject] locationInView:self.view];
	
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    if(CGRectContainsPoint(self.mapView.frame, pt)){
        
    }
	
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PlaceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    FSVenue *venue = self.placeArray[indexPath.row];

    label.text = venue.title;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
