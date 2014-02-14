//
//  MTAddCollectionViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-14.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTAddCollectionViewController.h"

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
   
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
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
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  
        if(indexPath.section==0){
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Title";
                    break;
                case 1:
                    cell.textLabel.text = @"Description";
                    break;
                case 2:
                    cell.textLabel.text =@"Category";
                    break;

                    
                default:
                    break;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.section==1){
            cell.textLabel.text = @"Show Map";
            UISwitch *swich = [[UISwitch alloc]initWithFrame:CGRectMake(250, 5, 100, 100)];
            [cell.contentView addSubview:swich];
            
            
        }
        else {
            cell.textLabel.text = @"Secret";
            UISwitch *swich = [[UISwitch alloc]initWithFrame:CGRectMake(250, 5, 100, 100)];
            [cell.contentView addSubview:swich];
            
            
        }

        
        
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
