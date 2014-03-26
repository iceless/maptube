//
//  MTProfileViewController.h
//  Maptube
//
//  Created by Bing W on 12/24/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *boardArray;
@property (nonatomic, strong) NSMutableDictionary *placeArray;
@property (nonatomic, strong) NSString *totalPlacesCount;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIButton *myMapButton;
@property (strong, nonatomic) UIButton *collectionButton;
@property (assign, nonatomic) int currentMap; 
//- (IBAction)logOutButtonTapAction:(id)sender;

@end
