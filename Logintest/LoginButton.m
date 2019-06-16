//
//  LoginButton.m
//  test
//
//  Created by shangshuai on 2018/8/15.
//  Copyright © 2018年 shangshuai. All rights reserved.
//

#import "LoginButton.h"
#import "UIColor+gradually.h"
#import "Masonry.h"
@interface LoginButton ()

@property (nonatomic, strong) CAGradientLayer *gradualLayer;

@property (nonatomic, strong) UILabel *ttle;

@property(strong,nonatomic) NSTimer *timer;

@property(assign,nonatomic) NSInteger count;

@end

@implementation LoginButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.allowed = NO;
    self.selected = YES;
    self.backgroundColor = [UIColor colorWithRed:43/255.0 green:75/255.0 blue:132/255.0 alpha:1];
    self.layer.cornerRadius = 25;
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:50/255.0 blue:224/255.0 alpha:1].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowRadius = 3;
    self.gradualLayer = [UIColor setGradualChangingColor2:self fromColor:@"#347EEF" toColor:@"#C87EEF"];
    [self.layer addSublayer:self.gradualLayer];
    [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ttle];
    [self.ttle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self).with.offset(0);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.gradualLayer.frame = self.bounds;
    });
    
    [self changeselected];
    [self changeselected];
}

#pragma mark - 添加定时器
- (void)timeFailBeginFrom:(NSInteger)timeCount {
    self.count = timeCount;
    self.enabled = NO;
    // 加1个定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo: nil repeats:YES];
}

#pragma mark - 定时器事件
- (void)timeDown {
    if (self.count != 1){
        self.count -=1;
        self.enabled = NO;
        [self noSelect];
        self.title = [NSString stringWithFormat:@"已发送(%ld)", self.count];
    } else {
        self.enabled = YES;
        [self select];
        self.title = @"获取验证码";
        [self.timer invalidate];
    }
}

- (void)btnClick:(UIButton *)btn {
    if (self.allowed) {
        [self changeselected];
    }
}

- (void)changeselected {
    self.selected = !self.selected;
    self.gradualLayer.hidden = !self.selected;
    self.layer.shadowOpacity = self.selected ? 0.8 : 0;
}

- (void)select {
    self.selected = YES;
    self.gradualLayer.hidden = NO;
    self.layer.shadowOpacity = self.selected ? 0.8 : 0;
}

- (void)noSelect {
    self.selected = NO;
    self.gradualLayer.hidden = YES;
    self.layer.shadowOpacity = self.selected ? 0.8 : 0;
}

- (void)layoutSubviews {
    self.gradualLayer.frame = self.bounds;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.ttle.text = title;
}

- (UILabel *)ttle {
    if (!_ttle) {
        _ttle = [[UILabel alloc] init];
        _ttle.textColor = [UIColor whiteColor];
        _ttle.font = [UIFont systemFontOfSize:20];
        _ttle.textAlignment = NSTextAlignmentCenter;
    }
    return _ttle;
}

@end
