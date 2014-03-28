//
//  MTEditPlacePhotoViewController.m
//  Maptube
//
//  Created by Vivian on 14-3-28.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTEditPlacePhotoViewController.h"

@interface MTEditPlacePhotoViewController ()

@end

@implementation MTEditPlacePhotoViewController

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
	// Do any additional setup after loading the view.
    self.title = @"Edit Photo";
    UIButton * button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 40, 32);
    [button addTarget:self action:@selector(chooseDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barItem;
    
    button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 40, 32);
    [button addTarget:self action:@selector(chooseDone) forControlEvents:UIControlEventTouchUpInside];
    barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=barItem;
    [self initPlaceView];
    [self initImageView];
}

-(void)initPlaceView{
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake(5, 60, 310, 50)];
    placeView.layer.borderWidth = 1;
    placeView.layer.borderColor = [UIColor grayColor].CGColor;
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 310, 20)];
    label.text = self.placeName;
    label.textAlignment = NSTextAlignmentLeft;
    [placeView addSubview:label];
    
    label  = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 310, 20)];
    label.text = self.location;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor grayColor];
    [placeView addSubview:label];
    
    [self.view addSubview:placeView];

}

-(void)initImageView{
    int width = 95;
    int height = 95;
    int x;
    int y;
    for(int i = 0;i<self.imageStrArray.count;i++){
        NSString *str = [self.imageStrArray objectAtIndex:i];
        UIImageView *view = [[UIImageView alloc]init];
        
        if(i%3==0)
            x = 15;
        else if(i%3==1)
            x = 115;
        else{
            x = 215;
        }
        if(i<=2) y = 120;
        else if(i>5) y = 330;
        else y = 225;
        view.frame = CGRectMake(x, y, width, height);
     
        view.tag = i;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer  *singleTap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(clickImage:)];
        
        [view addGestureRecognizer:singleTap];
        
        [view setImageWithURL:[NSURL URLWithString:str]];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mark.png"]];
        imgView.tag = 1;
        imgView.frame = CGRectMake(80, 0, 15, 15);
        [view addSubview:imgView];
        imgView.hidden = YES;
        [self.view addSubview:view];

    }
}

-(void)clickImage:(id)sender{
    
    NSInteger index = [(UIGestureRecognizer *)sender view].tag;
    UIImageView *view = (UIImageView *)[self.view viewWithTag:index];
    UIImageView *imgView = (UIImageView *)[view viewWithTag:1];
    imgView.hidden = !imgView.hidden;
    
}

-(void)chooseDone {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
