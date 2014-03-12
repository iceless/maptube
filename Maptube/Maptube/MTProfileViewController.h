//
//  MTProfileViewController.h
//  Maptube
//
//  Created by Bing W on 12/24/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *boardArray;
@property (nonatomic, strong) NSMutableDictionary *placeArray;


//- (IBAction)logOutButtonTapAction:(id)sender;

@end
