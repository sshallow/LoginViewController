//
//  LoginTextInput.m
//  test
//
//  Created by shangshuai on 2018/8/15.
//  Copyright © 2018年 shangshuai. All rights reserved.
//

#import "LoginTextInput.h"
#import "Masonry.h"
@interface LoginTextInput ()

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) UIView *line;

@end

@implementation LoginTextInput

- (instancetype)initWithFrame:(CGRect)frame withType:(LoginTextInputType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:type];
    }
    return self;
}

- (void)createUI:(LoginTextInputType)type {
    [self addSubview:self.btn];
    [self addSubview:self.clearBtn];
    [self addSubview:self.line];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self).with.offset(0);
        make.width.mas_equalTo(type == LoginTextInputInternationalCode || LoginTextInputVerificationCode ? @50 : @50);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@2);
        make.left.bottom.right.equalTo(self).with.offset(0);
    }];
    
//    self.textColor = [UIColor colorWithRed:52/255.0 green:126/255.0 blue:239/255.0 alpha:1.0];
    self.btn.selected = NO;
    if (type == LoginTextInputInternationalCode) {
        [_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        [_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    }
    self.rightView=self.clearBtn;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = self.btn;
}

- (void)btnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.psw) {
        NSString *tempStr = self.text;
        self.text = nil;
        self.secureTextEntry = !self.secureTextEntry;
        self.text = tempStr;
    }
}

- (void)clearBtn:(UIButton *)btn {
    if(self.editing) {
        self.text = @"";
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [placeholderString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor lightGrayColor]
                        range:NSMakeRange(0, placeholderString.length)];
    self.attributedPlaceholder = placeholderString;
}

- (void)setTittle:(NSString *)tittle {
    _tittle = tittle;
    [self.btn setTitle:tittle forState:UIControlStateNormal];
}

- (void)setSelectIc:(NSString *)selectIc {
    _selectIc = selectIc;
    [self.btn setImage:[UIImage imageNamed:selectIc] forState:UIControlStateSelected];
}

- (void)setNoSelectIc:(NSString *)noSelectIc {
    _noSelectIc = noSelectIc;
    [self.btn setImage:[UIImage imageNamed:noSelectIc] forState:UIControlStateNormal];
}

- (void)setPsw:(BOOL)psw {
    _psw = psw;
    self.secureTextEntry = YES;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_clearBtn addTarget:self action:@selector(clearBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_clearBtn setImage:[UIImage imageNamed:@"形状2拷贝"] forState:UIControlStateNormal];
    }
    return _clearBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:(47)/255.0 green:(141)/255.0 blue:(251)/255.0 alpha:1.0];
    }
    return _line;
}
@end
