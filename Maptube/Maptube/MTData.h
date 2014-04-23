//
//  MTData.h
//  Maptube
//
//  Created by Vivian on 14-3-4.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MTData : NSObject
@property(nonatomic,strong)UIImage *iconImage;
@property (nonatomic, assign) CLLocationCoordinate2D curCoordinate;
+(MTData*)sharedInstance;
+(NSString *)getCity:(NSDictionary *)dict;
+(CGSize)getSizebyString:(NSString *)str;
+ (UIImage*) createImageWithColor: (UIColor*) color;
@end
