//
//  MTEditProfileViewController.h
//  Maptube
//
//  Created by Bing W on 12/26/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTEditProfileViewController : UITableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *nLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imgview;

- (IBAction)logOutButtonTapAction:(id)sender;

@end
