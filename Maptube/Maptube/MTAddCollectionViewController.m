//
//  MTAddCollectionViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-14.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTAddCollectionViewController.h"
#import "MTEditDetailViewController.h"
#import <Parse/Parse.h>

@interface MTAddCollectionViewController ()

@end

@implementation MTAddCollectionViewController

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
    self.title =@"Create Board";
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 50, 32);
    [button addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=barItem;
    
    button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 50, 32);
    [button addTarget:self action:@selector(createBoard) forControlEvents:UIControlEventTouchUpInside];
    barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Create" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem=barItem;
    
    
   
    //self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    
    //[self.view addSubview:self.table];
   // self.table.delegate = self;
   // self.table.dataSource = self;
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    self.fields = @[@"Title", @"Description", @"Category", @"Show Map", @"Secret"];
    self.values = [@[@"", @"", @"", @"0", @"0"]mutableCopy];

    //PFUser *user = [PFUser currentUser];
    //self.values = @[@"", @"", @"Category", @"Show Map", @"Secret"];
    
    
}
-(void)navBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0) return 3;
    else return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
        else {
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

        
        
    
    return cell;
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MTEditDetailViewController *controller=[[MTEditDetailViewController alloc] init];
    controller.detailValue = self.values[indexPath.row];
    controller.indexPathRow = indexPath.row;
    controller.delegate =self;
    [self.navigationController pushViewController:controller animated:YES];
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditDetail"]) {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        MTEditDetailViewController *destViewController = segue.destinationViewController;
        destViewController.delegate = self;
        destViewController.detailValue = self.values[indexPath.row];
        destViewController.indexPathRow = indexPath.row;
    }
}
#pragma mark - MTEditDetailViewController source
-(void)updateValue:(NSString *)str atIndex:(NSInteger)i{
    self.values[i] = str;
    [self.table reloadData];
}

-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch *)sender;
    if(switchButton.tag==11){
        if(switchButton.on)
            self.values[3] = @"0";
        else self.values[3] = @"1";
        
    }
    else if(switchButton.tag==12){
        if(switchButton.on)
            self.values[4] = @"0";
        else self.values[4] = @"1";
        
    }

}
-(void)createBoard{
    PFUser *user = [PFUser currentUser];
    NSMutableArray *boardArray = user[@"Board"];
    if(!boardArray){
        boardArray = [NSMutableArray array];
        
        
    }
    [boardArray addObject:self.values];
    user[@"Board"] = boardArray;
    [user saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
