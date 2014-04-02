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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithData:(NSMutableArray *)array andPFObject:(PFObject *)object{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
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
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 50, 32);
    [button addTarget:self action:@selector(saveBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barItem;
   
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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
    UITableViewCell *cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    if(indexPath.section==0){
        //cell =[tableView dequeueReusableCellWithIdentifier:n];
        cell.textLabel.text = self.fields[indexPath.row];
        if(indexPath.row!=0){
            cell.detailTextLabel.text = self.values[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            UITextField *textField= [[UITextField alloc]initWithFrame:CGRectMake(80,10,200,29)];
            textField.text = self.values[indexPath.row];
            textField.textAlignment = NSTextAlignmentRight;
            textField.delegate = self;
            textField.tag = indexPath.row;
            [cell.contentView addSubview:textField];
            
            
        }

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
   
    else {
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
    else{
        MTEditDetailViewController *destViewController = [[MTEditDetailViewController alloc]init];
        destViewController.delegate = self;
        destViewController.detailValue = self.values[indexPath.row];
        destViewController.indexPathRow = indexPath.row;
        [self.navigationController pushViewController:destViewController animated:YES];

    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    _values[0] = textField.text;
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)saveBoard{
    self.mapObject[Title] = self.values[0];
    self.mapObject[Description] = self.values[1];
    self.mapObject[Category] = self.values[2];
    self.mapObject[Secret] = self.values[3];
    [self.mapObject saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:ModifyBoardNotification object:nil];
    }];
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
