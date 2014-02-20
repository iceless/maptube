//
//  FSConverter.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import "FSConverter.h"
#import "FSVenue.h"

@implementation FSConverter

- (NSArray *)convertToObjects:(NSArray *)venues {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues.count];
    for (NSDictionary *v  in venues) {
        FSVenue *ann = [[FSVenue alloc]init];
        ann.name = v[@"name"];
        ann.venueId = v[@"id"];

        ann.location.address = v[@"location"][@"address"];
        ann.location.distance = v[@"location"][@"distance"];
        
        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                      [v[@"location"][@"lng"] doubleValue])];
        [objects addObject:ann];
    }
    return objects;
}
+(NSArray *)objectsConvertToVenues:(NSArray *)array {
    
    NSMutableArray *venuesArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict  in array) {
        FSVenue *venue = [[FSVenue alloc]init];
        venue.name = dict[@"Title"];
        venue.venueId = dict[@"VenueId"];
        venue.location.address = dict[@"VenueAddress"];
        venue.location.distance = dict[@"Distance"];
        [venue.location setCoordinate:CLLocationCoordinate2DMake([dict[@"Latitude"] doubleValue],
                                                               [dict[@"Longitude"] doubleValue])];
        [venuesArray addObject:venue];
    
    }
    return venuesArray;
    
}

@end
