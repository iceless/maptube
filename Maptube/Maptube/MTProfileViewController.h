//
//  MTProfileViewController.h
//  Maptube
//
//  Created by Bing W on 12/24/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTProfileViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;

//- (IBAction)logOutButtonTapAction:(id)sender;

@end
