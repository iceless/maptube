//
//  MTEditProfileViewController.m
//  Maptube
//
//  Created by Bing W on 12/26/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import "MTEditProfileDetailViewController.h"
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



// Since this is static cells, so not supposed to use "cellForRowAtIndexPath", 
// which will mess up with existing framwork.
// same with "numberOfRowsInSection" and "numberOfSectionsInTableView"

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
        
        UILabel *label;
        
        label = (UILabel *)[cell.contentView viewWithTag:2];
        label.text = @"Profile Picture";
        
//        self.nLabel.text = @"Profile Picture";
        
        UIImageView *imgv;
        imgv = (UIImageView *)[cell.contentView viewWithTag:1];
        imgv.image = [UIImage imageNamed:@"profilepic.JPG"];
//        self.imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profilepic.JPG"]];
        
//        cell.textLabel.text = @"Profile Picture";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    } else {
        static NSString *CellIdentifier = @"detailcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];

        switch (indexPath.row) {
            case 0:
                label.text = @"First Name";
                break;
            case 1:
                label.text = @"Last Name";
                break;
            case 2:
                label.text = @"Username";
                break;
            case 3:
                label.text = @"Description";
                break;
            case 4:
                label.text = @"Location";
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

//why this functino called twice??
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* In this example, there is a different cell for
     the top, middle and bottom rows of the tableView.
     Each type of cell has a different height.
     self.model contains the data for the tableview
     */
    static NSString *cellIdentifier;
    if (indexPath.section == 0)
        cellIdentifier = @"profilepiccell";
    else if (indexPath.section == 1)
        cellIdentifier = @"detailcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell.bounds.size.height;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editProfileDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MTEditProfileDetailViewController *destViewController = segue.destinationViewController;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:2];
        destViewController.detailwhat = label.text;
    }
}


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
