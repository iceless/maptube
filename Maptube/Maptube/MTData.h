//
//  MTData.h
//  Maptube
//
//  Created by Vivian on 14-3-4.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTData : NSObject
@property(nonatomic,strong)UIImage *iconImage;
+(MTData*)sharedInstance;
@end
