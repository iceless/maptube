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

-(id)initWithData:(NSMutableArray *)array andPFObject:(PFObject *)object{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        UIStoryboard * storyBoard  = [UIStoryboard
                                      storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"EditBoard"];
        self.values = array;
        self.mapObject = object;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.fields = @[@"Title", @"Description", @"Category", @"Secret"];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.table reloadData];
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
        cell.textLabel.text = @"Secret";
        
        UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(250, 5, 100, 100)];
        switchButton.tag = 12;
        NSString *str = self.values[3];
        
        BOOL secret = str.boolValue;
        if(!secret)
            switchButton.on = FALSE;
        else switchButton.on = TRUE;
        
        [cell.contentView addSubview:switchButton];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
        
        
    }
   
    else{
        UILabel *label = [[UILabel alloc]initWithFrame:cell.frame];
        label.text =@"Delete Board";
        label.textAlignment = NSTextAlignmentCenter;
       
        [cell.contentView addSubview:label];
        
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      //delete board
    if(indexPath.section==2){
        [self.mapObject deleteInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:ModifyBoardNotification object:nil];
        
        
        }];
        
    }
    

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditBoardDetail"]) {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        MTEditDetailViewController *destViewController = segue.destinationViewController;
        destViewController.delegate = self;
        destViewController.detailValue = self.values[indexPath.row];
        destViewController.indexPathRow = indexPath.row;
    }
}
-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch *)sender;
    //if(switchButton.tag==11){
    if(switchButton.on)
        self.values[3] =  [NSNumber numberWithBool:NO];
    else
        self.values[3] = [NSNumber numberWithBool:YES];
}
-(void)updateValue:(NSString *)str atIndex:(NSInteger)i{
    self.values[i] = str;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
