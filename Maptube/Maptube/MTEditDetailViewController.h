//
//  MTEditDetailViewController.h
//  Maptube
//
//  Created by Vivian on 14-2-17.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MTEditDetailViewDelegate;
@interface MTEditDetailViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITextView *detailTextView;
@property (nonatomic, strong) NSString *detailValue;
@property (nonatomic) NSInteger indexPathRow;
@property(nonatomic,weak)id<MTEditDetailViewDelegate>delegate;

- (IBAction)doneButtonTapAction:(id)sender;

@end


@protocol MTEditDetailViewDelegate <NSObject>

-(void)updateValue:(NSString *)str atIndex:(NSInteger)i;
@end