//
//  MTProfileViewController.h
//  Maptube
//
//  Created by Bing W on 12/24/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,UITextViewDelegate>


@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *myMapArray;
@property (nonatomic, strong) NSMutableArray *favoriteMapArray;
@property (nonatomic, strong) NSString *totalPlacesCount;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIButton *myMapButton;
@property (strong, nonatomic) UIButton *collectionButton;
@property (assign, nonatomic) int currentMap; 
@property (strong, nonatomic) AVUser *user;
@property (nonatomic,strong)  UIImage *userImage;

@end
