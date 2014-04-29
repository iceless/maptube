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
@interface MTChooseBoardViewController : MTBaseViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) FSVenue *venue;
@property (strong, nonatomic) NSArray  *boardArray;
@property (strong, nonatomic) UITextField *describeTextField;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;
@property (strong, nonatomic) MTPlace *place;
-(id)initWithImage:(UIImage *)image AndVenue:(FSVenue *)venue;

@end
