//
//  MTPlace.h
//  Maptube
//
//  Created by Vivian on 14-2-21.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface MTPlace  : AVObject<MKAnnotation,AVSubclassing>
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *venueId;
@property (nonatomic,strong)NSString *description;
@property (nonatomic,strong)NSString *venueAddress;
//@property (nonatomic,strong)NSNumber *distance;
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

+(NSArray *)convertPlaceArray:(NSArray *)array;
+ (CGRect)updateMemberPins:(NSArray *)members;
@end
