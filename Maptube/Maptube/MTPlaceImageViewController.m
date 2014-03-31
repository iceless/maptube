//
//  MTPlaceImageViewController.m
//  Maptube
//
//  Created by Vivian on 14-3-31.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTPlaceImageViewController.h"

@implementation MTPlaceImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.imageUrlArray.count, self.view.frame.size.height);
    

    
     for (int i=0; i<self.imageUrlArray.count; i++){
        
        NSString *imgStr = [self.imageUrlArray objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*i+20, self.view.frame.size.height/2-140, 280, 280)];
        [imgView setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
        [imgView setUserInteractionEnabled:YES];
        
        [self.scrollView addSubview:imgView];
    }
    [self.view addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 60, 320, 20)];
    [self.pageControl setBackgroundColor:[UIColor blackColor]];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.imageUrlArray count];
    //[self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    int size  = self.view.frame.size.width; //屏幕视图的宽度
    int page = self.scrollView.contentOffset.x/size; //根据m_sc视图的偏移量来计算当前页数
    self.pageControl.currentPage = page;  //改变m_pageC的当前页
    
}

@end
