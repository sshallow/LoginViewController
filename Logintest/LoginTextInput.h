//
//  LoginTextInput.h
//  test
//
//  Created by shangshuai on 2018/8/15.
//  Copyright © 2018年 shangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoginTextInputType) {
    LoginTextInputNormal,
    LoginTextInputInternationalCode,
    LoginTextInputVerificationCode,
    LoginTextInputPsw,
};

@interface LoginTextInput : UITextField

@property (nonatomic, assign) LoginTextInputType type;

@property (nonatomic, copy) NSString *selectIc;

@property (nonatomic, copy) NSString *noSelectIc;

@property (nonatomic, copy) NSString *tittle;

@property (nonatomic, assign) BOOL psw;

- (instancetype)initWithFrame:(CGRect)frame withType:(LoginTextInputType)type;

@end
