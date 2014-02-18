//
//  MTAddPictureViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-18.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"

@interface MTAddPictureViewController : UIViewController
@property (strong, nonatomic) NSArray *picArray;
@property (strong, nonatomic) FSVenue *venue;

-(id)initWithImageArray:(NSArray *)array AndVenue:(FSVenue *)venue;
@end
