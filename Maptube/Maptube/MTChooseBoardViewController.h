//
//  MTChooseBoardViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-18.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"
#import "MTPlace.h"
#import "MTMap.h"
@interface MTChooseBoardViewController : MTBaseViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) FSVenue *venue;
@property (strong, nonatomic) NSMutableArray  *mapArray;
@property (strong, nonatomic) UITextField *describeTextField;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;
@property (strong, nonatomic) MTPlace *place;
@property (strong, nonatomic) MTMap *map;
-(id)initWithImage:(UIImage *)image AndVenue:(FSVenue *)venue;

@end
