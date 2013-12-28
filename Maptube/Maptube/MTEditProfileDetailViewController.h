//
//  MTEditProfileDetailViewController.h
//  Maptube
//
//  Created by Bing W on 12/27/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTEditProfileDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *detailtextview;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;
//have to use detailwhat to pass the string value to detailtextview.text,
//since at very beginning, you can't assign detailtextview.text from the previous view controller
// through controller
@property (nonatomic, strong) NSString *detailvalue;
@property (nonatomic) NSInteger indexpathrow;

- (IBAction)doneButtonTapAction:(id)sender;

@end
