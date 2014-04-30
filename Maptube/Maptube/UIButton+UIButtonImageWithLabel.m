//
//  UIButtonImageWithLable.m
//  Maptube
//
//  Created by Vivian on 14-4-30.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "UIButton+UIButtonImageWithLabel.h"

@implementation UIButton (UIButtonImageWithLabel)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0]];
    
     [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                              0.0,
                                              0.0,
                                              0.0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.titleLabel setTextColor:[UIColor lightGrayColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                              10.0,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
