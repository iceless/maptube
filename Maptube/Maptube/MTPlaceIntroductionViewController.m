//
//  MTPlaceIntroductionViewController.m
//  Maptube
//
//  Created by Vivian on 14-2-19.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTPlaceIntroductionViewController.h"
#import "MTChooseBoardViewController.h"

@interface MTPlaceIntroductionViewController ()

@end

@implementation MTPlaceIntroductionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithData:(NSDictionary *)dict AndVenue:(FSVenue *)venue{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        
        
        //self.view.backgroundColor = [UIColor grayColor];
        UIStoryboard * storyBoard  = [UIStoryboard
                                      storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"PlaceIntroduction"];
        self.placeData = dict;
        self.venue = venue;
        
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 120, 32);
    [button addTarget:self action:@selector(pin) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Add To Board" forState:UIControlStateNormal];
    //[button setBackgroundColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem=barItem;
    
    self.titleLabel.text = [self.placeData objectForKey:@"name"];
    NSDictionary *categoryDict = [self.placeData objectForKey:@"catogories"];
    NSDictionary *pictureDict = [self.placeData objectForKey:@"photos"];
    NSArray *array = [pictureDict objectForKey:@"groups"];
    if(array.count!=0){
        pictureDict = [array objectAtIndex:0];
        NSArray *picArray = [pictureDict objectForKey:@"items"];
        
        NSDictionary *picDict = [picArray objectAtIndex:0];
        NSString *str= [picDict objectForKey:@"prefix"];
        str = [str stringByAppendingString:@"60x60"];
        str = [str stringByAppendingString:[picDict objectForKey:@"suffix"]];
            NSLog(@"%@",str);
        [self.iconImageView setImageWithURL:[NSURL URLWithString:str]];
        
            
        
    }

    
}

-(void)pin{
    
    MTChooseBoardViewController *controller = [[MTChooseBoardViewController alloc]initWithImage:self.iconImageView.image AndVenue:self.venue];
    controller.view.frame = CGRectMake(10, 100, self.view.frame.size.width-20, self.view.frame.size.height);
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
