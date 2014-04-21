//
//  MTPlaceImageViewController.h
//  Maptube
//
//  Created by Vivian on 14-3-31.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTPlaceImageViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;
@property (strong, nonatomic) NSMutableArray *avFileImageArray;
@property(nonatomic, strong)UIPageControl *pageControl;
@end
