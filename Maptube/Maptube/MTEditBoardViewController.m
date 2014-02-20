//
//  MTEditBoardViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-20.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTEditBoardViewController.h"

@interface MTEditBoardViewController ()

@end

@implementation MTEditBoardViewController

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
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0) return 3;
    else return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    
    
    if(indexPath.section==0){
        cell =[tableView dequeueReusableCellWithIdentifier:@"CollectionDetailCell"];
        cell.textLabel.text = self.fields[indexPath.row];
        cell.detailTextLabel.text = self.values[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section==1){
        cell.textLabel.text = @"Show Map";
        UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(250, 5, 100, 100)];
        switchButton.tag = 11;
        
        if([self.values[3] isEqualToString:@"0"])
            switchButton.on = FALSE;
        else switchButton.on = TRUE;
        
        [cell.contentView addSubview:switchButton];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        
    }
    else if(indexPath.section==2){
        cell.textLabel.text = @"Secret";
        
        UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(250, 5, 100, 100)];
        switchButton.tag = 12;
        
        if([self.values[4] isEqualToString:@"0"])
            switchButton.on = FALSE;
        else switchButton.on = TRUE;
        
        [cell.contentView addSubview:switchButton];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
        
        
    }
    else if(indexPath.section==3){
    }
    else{
        
        
    }
    
    
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
