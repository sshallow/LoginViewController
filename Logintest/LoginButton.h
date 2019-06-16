//
//  LoginButton.h
//  test
//
//  Created by shangshuai on 2018/8/15.
//  Copyright © 2018年 shangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginButton : UIButton

@property (nonatomic, assign) BOOL allowed;

@property (nonatomic, copy) NSString *title;

- (void)changeselected;

- (void)select;

- (void)noSelect;

- (void)timeFailBeginFrom:(NSInteger)timeCount;

@end
