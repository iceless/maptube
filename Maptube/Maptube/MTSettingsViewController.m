//
//  MTSettingsViewController.m
//  Maptube
//
//  Created by Bing W on 12/26/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "MTSettingsViewController.h"
#import "MTEditProfileViewController.h"
#import "MTLoginViewController.h"

@interface MTSettingsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation MTSettingsViewController

- (void)loadView
{
    [super loadView];
    
    [self configViewHierarchy];
}

- (void)configViewHierarchy
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Edit Profile";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Credits";
    }
    else if (indexPath.section == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Log out";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        MTEditProfileViewController *targetVC = [[MTEditProfileViewController alloc] init];
        [self.navigationController pushViewController:targetVC animated:YES];
    }
    else if (indexPath.section == 1) {
        
    }
    else if (indexPath.section == 2) {
        [AVUser logOut];
        
        MTLoginViewController *logInViewController = [[MTLoginViewController alloc]init];
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

@end
