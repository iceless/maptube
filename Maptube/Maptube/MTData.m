//
//  MTData.m
//  Maptube
//
//  Created by Vivian on 14-3-4.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTData.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation MTData
+(MTData*)sharedInstance{
    static dispatch_once_t once;
    static MTData * __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[MTData alloc] init]; } );
    return __singleton__;
}

-(id)init{
    self=[super init];
    if (self) {
      
        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
        PFUser *user = [PFUser currentUser];
        [query whereKey:@"user" equalTo:user];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(objects.count!=0){
                PFObject *object = [objects objectAtIndex:0];
                PFFile *theImage = [object objectForKey:@"imageFile"];
                NSData *imageData = [theImage getData];
                self.iconImage = [UIImage imageWithData:imageData];
               

            }
            
            
        }];
  
    }
    return self;
}
@end
