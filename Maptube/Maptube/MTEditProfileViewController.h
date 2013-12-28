//
//  MTEditProfileViewController.h
//  Maptube
//
//  Created by Bing W on 12/26/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTEditProfileViewController : UITableViewController

//static string array for profile detail fields
@property (nonatomic, strong) NSArray *fields;
//mutable string array for profile detail values
@property (nonatomic, strong) NSMutableArray *values;

- (IBAction)saveButtonTapAction:(id)sender;

@end
