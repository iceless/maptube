//
//  MTMap.h
//  Maptube
//
//  Created by Vivian on 14-4-10.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface MTMap : NSObject
@property (nonatomic,strong)AVObject *mapObject;
@property (nonatomic,strong)AVUser *author;
@property (nonatomic,strong)NSArray *placeArray;
@property (nonatomic,strong)NSArray *collectUsers;
@property (nonatomic,strong)UIImage *authorImage;

-(void)initData;
-(void)initPlace;
@end
