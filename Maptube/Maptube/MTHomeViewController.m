//
//  MTHomeViewController.m
//  Maptube
//
//  Created by Vivian on 14-3-25.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTHomeViewController.h"
#import "MTMapCell.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MTHomeViewController ()

@end

@implementation MTHomeViewController

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
    self.title = @"MapTube";
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.table.delegate =self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    [self.table registerNib:[UINib nibWithNibName:@"MapCell" bundle:nil] forCellReuseIdentifier:@"PlaceSummaryCell"];
     //[self updateMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateMap{
    AVQuery *query = [AVQuery queryWithClassName:Map];
    //[query addDescendingOrder:CollectUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@",error);
        for(int i=0;i<10;i++){
            [self.mapList addObject:[objects objectAtIndex:i]];
        }
    
        [self.table reloadData];
    }];
    
}

#pragma mark - Table view data delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AVObject *mapObject = [self.mapList objectAtIndex:indexPath.row];
    
    MTMapCell *cell = [[MTMapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlaceSummaryCell"];
    cell.nameLabel = [mapObject objectForKey:Title];
    
    return cell;
}

@end
