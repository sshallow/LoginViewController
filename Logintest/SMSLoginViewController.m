//
//  SMSLoginViewController.m
//  AutoBotOS
//
//  Created by shangshuai on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SMSLoginViewController.h"
#import "LoginTextInput.h"
#import "LoginButton.h"
#import "ThirdPartLogin.h"
#import "ChangePswViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "NSString+MD5.h"
#import "UIViewController+alert.h"
#import "Masonry/Masonry.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface SMSLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) LoginTextInput *phoneText;

@property (nonatomic, strong) LoginTextInput *verificationCodeText;

@property (nonatomic, strong) LoginButton *send;

@property (nonatomic, strong) LoginButton *loginButton;

@property (nonatomic, strong) ThirdPartLogin *thirdPartLogin;

@property (nonatomic, strong) UIButton *privacy;

@property (nonatomic, copy) NSString *code;
@end

@implementation SMSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    self.thirdPartLogin.array = self.array;
    self.thirdPartLogin.hidden = YES;
}

- (void)setUI {
    [self.view addSubview:self.phoneText];
    [self.view addSubview:self.verificationCodeText];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.send];
    [self.view addSubview:self.thirdPartLogin];
    [self.view addSubview:self.privacy];

    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(55);
        make.left.equalTo(self.view).with.offset(35);
        make.right.equalTo(self.view).with.offset(-35);
        make.height.mas_equalTo(@50);
    }];
    [self.verificationCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneText.mas_bottom).with.offset(30);
        make.left.equalTo(self.view).with.offset(35);
        make.right.equalTo(self.view).with.offset(-125);
        make.height.mas_equalTo(@50);
    }];
    [self.send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneText.mas_bottom).with.offset(40);
        make.left.equalTo(self.verificationCodeText.mas_right);
        make.right.equalTo(self.view).with.offset(-35);
        make.height.mas_equalTo(@40);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationCodeText.mas_bottom).with.offset(60);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.width.mas_equalTo(@300);
        make.height.mas_equalTo(@50);
    }];
    [self.privacy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.width.mas_equalTo(@300);
        make.height.mas_equalTo(@20);
    }];
    [self.thirdPartLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).with.offset(120);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(@130);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@""]) return YES;
    
    if (textField == self.phoneText && textField.text.length >= 11) {
        return NO;
    }else if (self.verificationCodeText.text.length >= 4) return NO;
    NSString *validRegEx =@"^[0-9]$";
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    return myStringMatchesRegEx;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

- (void)send:(UIButton *)btn {
    if (self.phoneText.text.length < 11) {
        [self alert:@"请输入正确的手机号"];
    } else {
        [SVProgressHUD showWithStatus:nil];
//        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneText.text zone:@"86" template:nil result:^(NSError *error) {
//            if (!error) {
//                [self.send timeFailBeginFrom:60];
//                [SVProgressHUD showSuccessWithStatus:@"已发送"];
//            } else {
//                [SVProgressHUD showErrorWithStatus:@"发送失败，请重试"];
//            }
//        }];
    }
}

- (void)registerNum {
    NSString *md5token = [[NSString stringWithFormat:@"%@autobot$s$",self.phoneText.text] md5:[NSString stringWithFormat:@"%@autobot$s$",self.phoneText.text]];
    NSDictionary * parameter = @{@"phone":self.phoneText.text,@"token":md5token};
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *baseUrl = [NSString stringWithFormat:@"http://54.222.213.58:5000/reg"];
    [SVProgressHUD showWithStatus:@"Loading..."];
    [mgr POST:baseUrl parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneText.text forKey:@"phonenum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            ChangePswViewController *vc = [[ChangePswViewController alloc]init];
            vc.num = self.phoneText.text;
            vc.title = @"修改密码";
        }else if ([dic[@"status"] integerValue] == 400) {
            [self alert:@"该手机号已经注册"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(UIButton *)btn {
    [self verificationCode];
}

- (void)login {
    NSString *md5 = [self.phoneText.text md5:[NSString stringWithFormat:@"%@autobot$s$",self.phoneText.text]];
    NSDictionary * parameter = @{@"phone":self.phoneText.text,@"token":md5};
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *baseUrl = [NSString stringWithFormat:@"http://54.222.213.58:5000/loginuser"];
    [SVProgressHUD showWithStatus:@"Loading..."];
    [mgr POST:baseUrl parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneText.text forKey:@"phonenum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backAction" object:nil];
        }else if ([dic[@"status"] integerValue] == 404) {
            [self alert:@"用户不存在"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)privacyBtn {
    NSURL *url = [NSURL URLWithString:@"http://autobot.im/service_term.html"];
//    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
//    [self presentViewController:safariVC animated:YES completion:nil];
    
}

- (void)verificationCode {
//    [SMSSDK commitVerificationCode:self.verificationCodeText.text phoneNumber:self.phoneText.text zone:@"86" result:^(NSError *error) {
//
//        if (!error) {
//            if (self.willregister) {
//                [self registerNum];
//            } else {
//                [self login];
//            }
//        }
//        else
//        {
//            [self alert:@"验证码有误"];
//        }
//    }];
}

- (LoginTextInput *)phoneText {
    if (!_phoneText) {
        _phoneText = [[LoginTextInput alloc] initWithFrame:CGRectZero withType:LoginTextInputNormal];
        _phoneText.delegate = self;
        _phoneText.placeholder = @"请输入手机号";
        _phoneText.tittle = @"+86";
    }
    return _phoneText;
}

- (LoginTextInput *)verificationCodeText {
    if (!_verificationCodeText) {
        _verificationCodeText = [[LoginTextInput alloc] initWithFrame:CGRectZero withType:LoginTextInputPsw];
        _verificationCodeText.delegate = self;
        _verificationCodeText.placeholder = @"请输入验证码";
        _verificationCodeText.tittle = @"验证码";
    }
    return _verificationCodeText;
}

- (LoginButton *)send {
    if (!_send) {
        _send = [[LoginButton alloc] init];
        [_send addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
        _send.title = @"获取验证码";
    }
    return _send;
}

- (LoginButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[LoginButton alloc] init];
        [_loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.title = self.willregister ? @"注册" : @"登录";
    }
    return _loginButton;
}

- (ThirdPartLogin *)thirdPartLogin {
    if (!_thirdPartLogin) {
        _thirdPartLogin = [[ThirdPartLogin alloc] init];
    }
    return _thirdPartLogin;
}

- (NSMutableArray *)array {
    if (!_arr) {
        _arr = [[NSMutableArray alloc] init];
    }
    return _arr;
}

- (UIButton *)privacy {
    if (!_privacy) {
        _privacy = [[UIButton alloc] init];
        NSMutableAttributedString*str = [[NSMutableAttributedString alloc]initWithString:@"注册或登录同意隐私条款"];
        NSRange strRange = {0,str.length};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]range:strRange];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]  range:strRange];
        [_privacy setAttributedTitle:str forState:UIControlStateNormal];
        //        [_privacy setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:@"123456" attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}] forState:UIControlStateNormal];
        _privacy.titleLabel.font = [UIFont systemFontOfSize:12];
        [_privacy addTarget:self action:@selector(privacyBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privacy;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
