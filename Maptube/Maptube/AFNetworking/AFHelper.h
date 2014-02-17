//
//  AFHelper.h
//  anlley
//
//  Created by Freedom on 13-11-6.
//  Copyright (c) 2013年 ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFHelper : NSObject
+(void)AFConnectionWithURL:(NSURL *)url andStr:(NSString *)aStr compeletion:(void (^)(id))completion;

@end
