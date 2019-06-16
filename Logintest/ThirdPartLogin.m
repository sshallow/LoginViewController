//
//  ThirdPartLogin.m
//  test
//
//  Created by shangshuai on 2018/8/15.
//  Copyright © 2018年 shangshuai. All rights reserved.
//

#import "ThirdPartLogin.h"
#import "Masonry.h"
@interface ThirdPartLogin ()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UIView *line1;

@property (nonatomic, strong) NSMutableArray *btnarry;
@end

@implementation ThirdPartLogin

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.line];
    [self addSubview:self.title];
    [self addSubview:self.line1];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(25);
        make.left.equalTo(self).with.offset(40);
        make.height.mas_equalTo(@1);
        make.right.equalTo(self.title.mas_left).with.offset(-10);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.line.mas_centerY).with.offset(0);
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.width.mas_equalTo(@160);
        make.height.mas_equalTo(@25);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line).with.offset(0);
        make.right.equalTo(self).with.offset(-40);
        make.height.mas_equalTo(@1);
        make.left.equalTo(self.title.mas_right).with.offset(10);
    }];
    
    self.array = [[NSMutableArray alloc]init];
    
    NSArray *subViews = @[self.line,self.line1];
    [subViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        subView.backgroundColor = [UIColor grayColor];
    }];
}

- (void)setArray:(NSMutableArray *)array {
    _array = array;
    if (array.count <= 0) return;
    if (array.count == 1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:array[0][@"img"]] forState:UIControlStateNormal];
        [self.array addObject:btn];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@68);
            make.centerX.equalTo(self.mas_centerX).with.offset(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        return ;
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:obj[@"img"]] forState:UIControlStateNormal];
        [self.btnarry addObject:btn];
        [self addSubview:btn];
    }];
    [self.btnarry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:50 tailSpacing:50];
    [self.btnarry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@68);
        make.height.equalTo(@50);
    }];
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
    }
    return _line;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor lightGrayColor];
        _title.font = [UIFont systemFontOfSize:14];
        _title.text = @"使用第三方账号登录";
    }
    return _title;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
    }
    return _line1;
}

- (NSMutableArray *)btnarry {
    if (!_btnarry) {
        _btnarry = [[NSMutableArray alloc] init];
    }
    return _btnarry;
}
@end
