//
//  MTMap.m
//  Maptube
//
//  Created by Vivian on 14-4-10.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTMap.h"

@implementation MTMap
-(void)initData{

    PFRelation *placeRelation = [self.mapObject relationforKey:Place];
    AVQuery *pquery = [placeRelation query];
    [pquery includeKey:PlacePhotos];
    [pquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.placeArray = objects;
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshTableViewNotification object:nil];
        //if(self.authorImage&&self.collectUsers)
            //self.finishInit = true;
    }];
    
    AVUser *user = [self.mapObject objectForKey:Author];
    AVQuery *query =[AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:[user objectForKey:@"objectId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.author = objects[0];
        [self initIcon];
    }];
    
    AVRelation *collectRelation = [self.mapObject objectForKey:CollectUser];
    [collectRelation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.collectUsers = objects;
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshTableViewNotification object:nil];
        //if(self.authorImage&&self.placeArray)
            //self.finishInit = true;
    }];
    
}

-(void)initPlace{
    PFRelation *placeRelation = [self.mapObject relationforKey:Place];
    [[placeRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.placeArray = objects;
    }];
    
    AVRelation *collectRelation = [self.mapObject objectForKey:CollectUser];
    [collectRelation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.collectUsers = objects;
       
    }];
    
}

-(void)initIcon{
    AVObject *fileObject = [self.author objectForKey:@"Icon"];
    if(fileObject){
    NSString *fileObjectId = fileObject.objectId;
    AVQuery *photoQuery = [AVQuery queryWithClassName:@"UserPhoto"];
    [photoQuery whereKey:@"objectId" equalTo:fileObjectId];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count!=0){
        AVObject *photoObject = objects[0];
        AVFile *theImage = [photoObject objectForKey:@"imageFile"];
        NSData *imageData = [theImage getData];
        self.authorImage = [UIImage imageWithData:imageData];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshTableViewNotification object:nil];
        //if(self.collectUsers&&self.placeArray)
           // self.finishInit = true;
        }
    }];
    }
}
@end
