//
//  MTEditProfileViewController.m
//  Maptube
//
//  Created by Bing W on 12/26/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <Parse/Parse.h>
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
    
    //initial setting up, retrieve user's info
    PFUser *user = [PFUser currentUser];
    self.fields = @[@"First Name", @"Last Name", @"Username", @"Description", @"Location"];
    self.values = [@[user[@"firstname"],
                     user[@"lastname"],
                     user[@"username"],
                     user[@"description"],
                     user[@"location"]] mutableCopy];
}

//make sure everytime view appears, the table view's labels are updated from array values.
- (void)viewWillAppear:(BOOL)animated
{
    [self refreshTableViewData];
}

//refresh the tableview data, assign array string values to labels respectively 
- (void)refreshTableViewData
{
    for(int i = 0; i < 5; i++)
    {
        UILabel *labelvalue = (UILabel *)[[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]].contentView viewWithTag:2];
        labelvalue.text = self.values[i];
    }
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
        
        UIImageView *imgv;
        imgv = (UIImageView *)[cell.contentView viewWithTag:1];
        imgv.image = [UIImage imageNamed:@"profilepic.JPG"];
    } else if(indexPath.section == 1){
        static NSString *CellIdentifier = @"detailcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *labelValue = (UILabel *)[cell.contentView viewWithTag:2];

        label.text = self.fields[indexPath.row];
        labelValue.text = self.values[indexPath.row];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editProfileDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MTEditProfileDetailViewController *destViewController = segue.destinationViewController;
        destViewController.detailvalue = self.values[indexPath.row];
        destViewController.indexpathrow = indexPath.row;
    }
}

//saveButton to set the infos into PFUser, and send it to remote parse server
- (IBAction)saveButtonTapAction:(id)sender
{
    PFUser *user = [PFUser currentUser];
    user[@"firstname"] = _values[0];
    NSLog(@"%@",self.values[0]);
    user[@"lastname"] = _values[1];
    user[@"username"] = _values[2];
    user[@"description"] = _values[3];
    user[@"location"] = _values[4];
    [user saveInBackground];
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
