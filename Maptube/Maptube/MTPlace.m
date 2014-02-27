//
//  MTPlace.m
//  Maptube
//
//  Created by Vivian on 14-2-21.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTPlace.h"
#import <Parse/Parse.h>

@implementation MTPlace

+(NSArray *)convertPlaceArray:(NSArray *)array {
    
    NSMutableArray *placeArray = [NSMutableArray arrayWithCapacity:array.count];
    for (PFObject  *dict  in array) {
        MTPlace *place = [[MTPlace alloc]init];
        place.name = dict[Title];
        place.venueId = dict[VenueID];
        place.venueAddress = dict[VenueAddress];
        [place setCoordinate:CLLocationCoordinate2DMake([dict[Latitude] doubleValue],
                                                                 [dict[Longitude] doubleValue])];
        [placeArray addObject:place];
        
    }
    return placeArray;
    
}

+ (CGRect)updateMemberPins:(NSArray *)members{
    
    //calculate new region to show on map
    double center_long = 0.0f;
    double center_lat = 0.0f;
    double max_long = 0.0f;
    double min_long = 0.0f;
    double max_lat = 0.0f;
    double min_lat = 0.0f;
    
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
    
    //NSLog(@"center long: %f, center lat: %f", center_long, center_lat);
    //NSLog(@"max_long: %f, min_long: %f, max_lat: %f, min_lat: %f", max_long, min_long, max_lat, min_lat);
    
    return CGRectMake(center_lat,center_long, max_lat , max_long);
    
    //create new region and set map
    
}

@end
