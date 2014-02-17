//
//  AFHelper.m
//  anlley
//
//  Created by Vivi on 13-11-6.
//  Copyright (c) 2013年 ben. All rights reserved.
//

#import "AFHelper.h"

@implementation AFHelper
+(void)AFConnectionWithURL:(NSURL *)url andStr:(NSString *)aStr compeletion:(void (^)(id))completion
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if(aStr){
    NSData *postData = [aStr dataUsingEncoding: NSUTF8StringEncoding];
    
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"Get"];
        
    }
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        completion(JSON);
            
       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Get Data Failure"
                                                     message:[NSString stringWithFormat:@"%@",error]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }];
    [operation start];



}



@end
