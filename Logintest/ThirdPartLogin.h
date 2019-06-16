//
//  ThirdPartLogin.h
//  test
//
//  Created by shangshuai on 2018/8/15.
//  Copyright © 2018年 shangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThirdPartLoginDelegate <NSObject>

- (void)ThirdPartLoginDelegate;

@end

@interface ThirdPartLogin : UIView

@property (nonatomic, strong) NSMutableArray *array;

@end
