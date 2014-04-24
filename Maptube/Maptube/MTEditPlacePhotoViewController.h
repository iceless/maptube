//
//  MTEditPlacePhotoViewController.h
//  Maptube
//
//  Created by Vivian on 14-3-28.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTPlace.h"

@interface MTEditPlacePhotoViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSArray *imageStrArray;
//@property (strong, nonatomic) NSString *placeName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) MTPlace *place;
@property (strong, nonatomic) NSMutableArray *selectImageArray;
@property (assign, nonatomic) int totalImageCount;
@end
