//
//  MTPlace.h
//  Maptube
//
//  Created by Vivian on 14-2-21.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Mapbox.h"
#import <AVOSCloud/AVOSCloud.h>
#import "FSVenue.h"
@interface MTPlace  : AVObject<AVSubclassing>
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *venueId;
@property (nonatomic,strong)NSMutableArray *placePhotos;
@property (nonatomic,strong)NSString *venueAddress;
//@property (nonatomic,strong)NSNumber *distance;
//@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic,strong)NSNumber *latitude;
@property (nonatomic,strong)NSNumber *longitude;

+(NSArray *)convertPlaceArray:(NSArray *)array;
+(CGRect)updateMemberPins:(NSArray *)members;
-(void)getDataByVenue:(FSVenue *)venue;
@end
