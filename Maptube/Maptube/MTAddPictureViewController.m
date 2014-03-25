//
//  MTAddPictureViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-18.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTAddPictureViewController.h"
#import "MTChooseBoardViewController.h"

@interface MTAddPictureViewController ()

@end

@implementation MTAddPictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithImageArray:(NSArray *)array AndVenue:(FSVenue *)venue{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.picArray = array;
        self.venue = venue;
        self.view.backgroundColor = [UIColor grayColor];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Choose a picture";
    CGRect rect = CGRectMake(10, 70, 90, 90);

    for(int i=0;i<self.picArray.count;i++){
        
        if(i%3==0) {
            rect.origin.x = 10;
            if(i!=0)
            rect.origin.y += 100;
        }
        else {
            rect.origin.x+=100;
        }
        UIImageView *view = [[UIImageView alloc]initWithFrame:rect];
        [view setImageWithURL:[NSURL URLWithString:[self.picArray objectAtIndex:i]]];
        [view setUserInteractionEnabled:YES];
        [self.view addSubview:view];
        
        UIButton *button = [[UIButton alloc] initWithFrame:rect] ;
        button.tag = i;
        [button addTarget:self action:@selector(clickPicture:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        
    }
}

-(void)clickPicture:(id)sender{
   // UIButton *button = (UIButton *)sender;
   // MTChooseBoardViewController *controller = [[MTChooseBoardViewController alloc]initWithImageStr:[self.picArray objectAtIndex:button.tag] AndVenue:self.venue];
    //controller.view.frame = CGRectMake(10, 100, self.view.frame.size.width-20, self.view.frame.size.height);
    //[self.view addSubview:controller.view];
    //self.modalTransitionStyle
    //弹出选择board面板
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

    
}

@end
