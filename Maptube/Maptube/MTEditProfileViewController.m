//
//  MTEditProfileViewController.m
//  Maptube
//
//  Created by Bing W on 12/26/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import "MTEditProfileViewController.h"

@interface MTEditProfileViewController ()

@end

@implementation MTEditProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




- (void)configureView
{
    self.nLabel.text = @"Profile Picture";
    self.imgview.image = [UIImage imageNamed:@"profilepic.JPG"];
}


/*
 Since this is static cells, so not supposed to use "cellForRowAtIndexPath", 
 which will mess up with existing framwork.
 same with "numberOfRowsInSection" and "numberOfSectionsInTableView"
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0){
        static NSString *CellIdentifier = @"profilepiccell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            NSLog(@"not supposed to be here!!");
        }
        
//        UILabel *label;
//        
//        label = (UILabel *)[cell.contentView viewWithTag:2];
//        label.text = @"Profile Picture";
        
        self.nLabel.text = @"Profile Picture";
        
//        UIImageView *imgv;
//        imgv = (UIImageView *)[cell.contentView viewWithTag:1];
//        imgv.image = [UIImage imageNamed:@"profilepic.JPG"];
        self.imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profilepic.JPG"]];
        
//        cell.textLabel.text = @"Profile Picture";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    } else {
        static NSString *CellIdentifier = @"fieldcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"First Name";
                break;
            case 1:
                cell.textLabel.text = @"Last Name";
                break;
            case 2:
                cell.textLabel.text = @"Username";
                break;
            case 3:
                cell.textLabel.text = @"Description";
                break;
            case 4:
                cell.textLabel.text = @"Location";
                break;
            default:
                break;
        }
        
    }
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 //#warning Incomplete method implementation.
 // Return the number of rows in the section.
 NSInteger num = 0;
 if (section == 0) {
 num = 1;
 } else {
 num = 5;
 }
 return num;
 }
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 //#warning Potentially incomplete method implementation.
 // Return the number of sections.
 return 2;
 }

 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */



@end
