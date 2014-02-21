//
//  MTPlace.h
//  Maptube
//
//  Created by Vivian on 14-2-21.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MTPlace  : NSObject<MKAnnotation>
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *venueId;
@property (nonatomic,strong)NSString *description;
@property (nonatomic,strong)NSString *venueAddress;
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;


+(NSArray *)convertPlaceArray:(NSArray *)array;
@end
