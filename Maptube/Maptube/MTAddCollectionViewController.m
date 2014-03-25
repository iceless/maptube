//
//  MTAddCollectionViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-14.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTAddCollectionViewController.h"
#import "MTEditDetailViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MTAddCollectionViewController ()

@end

@implementation MTAddCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //UIStoryboard * storyBoard  = [UIStoryboard
          //                            storyboardWithName:@"Main" bundle:nil];
        //self = [storyBoard instantiateViewControllerWithIdentifier:@"AddBoard"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title =@"Create Map";
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.table.delegate =self;
    self.table.dataSource = self;
    
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
    //[button setBackgroundColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem=barItem;
    
    
   
    //self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    
    //[self.view addSubview:self.table];
   // self.table.delegate = self;
   // self.table.dataSource = self;
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    self.fields = @[@"Title", @"Description", @"Category", @"Secret"];
    self.values = [@[@"", @"", @"", [NSNumber numberWithBool:NO]]mutableCopy];

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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if(indexPath.section==0){
            //cell =[tableView dequeueReusableCellWithIdentifier:@"CollectionDetailCell"];
            cell.textLabel.text = self.fields[indexPath.row];
            cell.detailTextLabel.text = self.values[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    /*
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
     */
        else {
            cell.textLabel.text = @"Secret";
            
            UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(250, 5, 100, 100)];
            switchButton.tag = 12;
            NSNumber *secretNumber = self.values[3];
            if(secretNumber== [NSNumber numberWithBool:NO])
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MTEditDetailViewController *viewController = [[MTEditDetailViewController alloc]initWithValue:self.values[indexPath.row] andIndex:indexPath.row];
    viewController.delegate =self;
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}
#pragma mark - MTEditDetailViewController source
-(void)updateValue:(NSString *)str atIndex:(NSInteger)i{
    self.values[i] = str;
    [self.table reloadData];
}

-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch *)sender;
    //if(switchButton.tag==11){
        if(switchButton.on)
            self.values[3] =  [NSNumber numberWithBool:NO];
        else
            self.values[3] = [NSNumber numberWithBool:YES];
        
//    }
//    else if(switchButton.tag==12){
//        if(switchButton.on)
//            self.values[4] = @"0";
//        else self.values[4] = @"1";
//        
//    }

}
-(void)createBoard{
    PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *mapObject in objects){
            if([mapObject[Title] isEqualToString:self.values[0]])
            {
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"The same map name exsits,please change the title", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                return ;
                
            
            }
        
        }
        PFObject *mapObject = [PFObject objectWithClassName:Map];
        [mapObject setObject:self.values[0] forKey:Title];
        [mapObject setObject:self.values[1] forKey:Description];
        [mapObject setObject:self.values[2] forKey:Category];
        [mapObject setObject: self.values[3] forKey:Secret];
        [mapObject saveEventually: ^(BOOL succeeded, NSError *error) {
            if (!error) {
                PFRelation *relation = [[PFUser currentUser] relationforKey:Map];
                [relation addObject:mapObject];
                
                [[PFUser currentUser] saveEventually: ^(BOOL succeeded, NSError *error) {
                    if(succeeded){
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
