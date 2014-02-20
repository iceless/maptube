//
//  MTPlaceIntroductionViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-19.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"

@interface MTPlaceIntroductionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet NSDictionary *placeData;
@property (strong, nonatomic) IBOutlet FSVenue *venue;

-(id)initWithData:(NSDictionary *)dict AndVenue:(FSVenue *)venue;
@end
