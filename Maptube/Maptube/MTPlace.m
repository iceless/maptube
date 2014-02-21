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

@end
