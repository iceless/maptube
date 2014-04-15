//
//  MTPlace.m
//  Maptube
//
//  Created by Vivian on 14-2-21.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTPlace.h"
#import <AVOSCloud/AVObject.h>
//#import <Parse/Parse.h>

@implementation MTPlace
+ (NSString *)parseClassName {
    return @"Place";
}
+(NSArray *)convertPlaceArray:(NSArray *)array {
    
    NSMutableArray *placeArray = [NSMutableArray arrayWithCapacity:array.count];
    for (AVObject  *dict  in array) {
        MTPlace *place = [[MTPlace alloc]initWithMapView:nil coordinate:CLLocationCoordinate2DMake([dict[Latitude] doubleValue],
                                                                                                   [dict[Longitude] doubleValue]) andTitle:dict[Title]];
     
        place.venueId = dict[VenueID];
        place.venueAddress = dict[VenueAddress];
        [place setCoordinate:CLLocationCoordinate2DMake([dict[Latitude] doubleValue],
                                                                 [dict[Longitude] doubleValue])];
        //place.distance = dict[Distance];
        [placeArray addObject:place];
        
    }
    return placeArray;
    
}

+ (CGRect)updateMemberPins:(NSArray *)members{
    MTPlace *firstPlace = members[0];
    //calculate new region to show on map
    double center_long = 0.0f;
    double center_lat = 0.0f;
    double max_long = firstPlace.coordinate.longitude;
    double min_long = firstPlace.coordinate.longitude;
    double max_lat = firstPlace.coordinate.latitude;
    double min_lat = firstPlace.coordinate.latitude;
    
    for (MTPlace *member in members) {
        double lat, lng;
        lat = (double)member.coordinate.latitude;
        lng = (double)member.coordinate.longitude;
        //find min and max values
        if (lat > max_lat) {max_lat = lat;}
        if (lat < min_lat) {min_lat = lat;}
        if (lng > max_long) {max_long = lng;}
        if (lng < min_long) {min_long = lng;}
        
        //sum up long and lang to get average later
        center_lat = center_lat + lat;
        center_long = center_long + lng;
    }
    
    //calculate average long / lat
    center_lat = center_lat / [members count];
    center_long = center_long / [members count];
    CLLocation *maxLocation = [[CLLocation alloc]initWithLatitude:max_lat longitude:max_long];
    CLLocation *minLocation = [[CLLocation alloc]initWithLatitude:min_lat longitude:min_long];
    CLLocation *centerLocation  = [[CLLocation alloc]initWithLatitude:center_lat longitude:center_long];
    //NSLog(@"center long: %f, center lat: %f", center_long, center_lat);
    //NSLog(@"max_long: %f, min_long: %f, max_lat: %f, min_lat: %f", max_long, min_long, max_lat, min_lat);
    CLLocationDistance distance1 = [maxLocation distanceFromLocation:centerLocation];
    CLLocationDistance distance2 = [minLocation distanceFromLocation:centerLocation];
    CLLocationDistance distance = MAX(distance1, distance2);
   
    return CGRectMake(center_lat,center_long, distance*2+1500, distance*2+1500);
    
    //create new region and set map
    
}

@end
