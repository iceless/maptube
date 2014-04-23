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

+(CGSize)getSizebyString:(NSString *)str{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.text = str;
    label.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(310, 300);
    return  [label sizeThatFits:maximumLabelSize];
}

+(NSString *)getCity:(NSDictionary *)dict{
    NSArray *array = dict[@"results"][0];
    for(NSDictionary *resultDict in array)
    {
        NSString *str = resultDict[@"type"];
        if([str isEqualToString:@"city"]){
            
            return resultDict[@"name"];
        }
    
    }
    
    
    return nil;
}

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
