//
//  UIColor+gradually.h
//  test
//
//  Created by shangshuai on 2018/8/7.
//  Copyright © 2018年 shangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (gradually)

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;

+ (CAGradientLayer *)setGradualChangingColorRGB:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor cornerRadius:(CGFloat)cornerRadius;

+ (CAGradientLayer *)setGradualColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

+ (CAGradientLayer *)setGradualChangingColor2:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;

+ (UIColor *)colorWithHex:(NSString *)hexColor ;
@end
