//
//  LoginViewController.m
//  AutoBotOS
//
//  Created by shangshuai on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTextInput.h"
#import "LoginButton.h"
#import "ThirdPartLogin.h"
#import "SMSLoginViewController.h"
#import "NSString+MD5.h"
#import <SafariServices/SafariServices.h>
#import "AFNetworking/AFNetworking.h"
#import "Masonry/Masonry.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) LoginTextInput *phoneText;

@property (nonatomic, strong) LoginTextInput *pswText;

@property (nonatomic, strong) LoginButton *loginButton;

@property (nonatomic, strong) UIButton *SMSlogin;

@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic, strong) ThirdPartLogin *thirdPartLogin;

@property (nonatomic, strong) UIButton *privacy;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginBack) name:@"backAction" object:nil];
    [self setUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.array addObject:@{@"img":@"椭圆1",@"url":@""}];
    [self.array addObject:@{@"img":@"椭圆1",@"url":@""}];
    [self.array addObject:@{@"img":@"椭圆1",@"url":@""}];
    self.thirdPartLogin.array = self.array;
    self.thirdPartLogin.hidden = YES;
}

- (void)loginBack {
}

- (void)setUI {
    [self.view addSubview:self.phoneText];
    [self.view addSubview:self.pswText];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.SMSlogin];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.thirdPartLogin];
    [self.view addSubview:self.privacy];
    
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(55);
        make.left.equalTo(self.view).with.offset(35);
        make.right.equalTo(self.view).with.offset(-35);
        make.height.mas_equalTo(@50);
    }];
    [self.pswText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneText.mas_bottom).with.offset(30);
        make.left.equalTo(self.view).with.offset(35);
        make.right.equalTo(self.view).with.offset(-35);
        make.height.mas_equalTo(@50);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pswText.mas_bottom).with.offset(60);
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
    [self.SMSlogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).with.offset(25);
        make.left.equalTo(self.loginButton.mas_left).with.offset(0);
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(@50);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).with.offset(25);
        make.right.equalTo(self.loginButton.mas_right).with.offset(0);
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@50);
    }];
    [self.thirdPartLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SMSlogin.mas_bottom).with.offset(60);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(@130);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneText) {
        if ([string isEqualToString:@""]) return YES;
        if (textField.text.length >= 11) return NO;
        
        NSString *validRegEx =@"^[0-9]$";
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        return myStringMatchesRegEx;
    }
    if ([string isEqualToString:@""]) return YES;
    if (textField.text.length >= 16) return NO;

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)loginButton:(UIButton *)btn {
    if ([self verify]) {
        self.phonenum = self.phoneText.text;
        [self.phoneText endEditing:YES];
        [self.pswText endEditing:YES];
        [self loginRequest];
    }

}

- (void)SMSlogin:(UIButton *)btn {
    SMSLoginViewController *vc = [[SMSLoginViewController alloc]init];
    vc.title = @"登录";
    vc.willregister = NO;
    vc.arr = self.array;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)SMSregister:(UIButton *)btn {
    SMSLoginViewController *vc = [[SMSLoginViewController alloc]init];
    vc.title = @"登录";
    vc.arr = self.array;
    vc.willregister = YES;
}

- (BOOL)verify {
    if (self.phoneText.text.length < 11) {
        [self alerWith:@"请输入正确的手机号"];
        return NO;
    }else if (self.pswText.text.length < 6) {
        [self alerWith:@"密码不低于6位"];
        return NO;
    }
    return YES;
}

- (void)loginRequest {
    
    NSString *md5token = [[NSString stringWithFormat:@"%@autobot$s$",self.phoneText.text] md5:[NSString stringWithFormat:@"%@autobot$s$",self.phoneText.text]];
    NSString *md5passwd = [self.pswText.text md5:self.pswText.text];
    
    NSDictionary * parameter = @{@"phone":self.phoneText.text,@"token":md5token,@"passwd":md5passwd};
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *baseUrl = [NSString stringWithFormat:@"http://54.222.213.58:5000/loginuser"];
    [SVProgressHUD showWithStatus:@"Loading..."];
    [mgr POST:baseUrl parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self backAction];
            });
            [[NSUserDefaults standardUserDefaults] setObject:self.phonenum forKey:@"phonenum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if ([dic[@"status"] integerValue] == 404) {
            [self alerWith:@"用户名或密码有误"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)relogin {
    NSString *md5 = [self.phonenum md5:self.phonenum];
    NSDictionary * parameter = @{@"phone":self.phoneText.text,@"token":md5};
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *baseUrl = [NSString stringWithFormat:@"http://54.222.213.58:5000/loginuser"];
    [mgr POST:baseUrl parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            
        }else if ([dic[@"status"] integerValue] == 404) {
            [self alerWith:@"用户或密码有误"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)alerWith:(NSString *)alert {
    //STEP 1
    NSString *title = @"温馨提示";
    NSString *message = alert;
    NSString *okButtonTitle = @"好的";
    
    //step 2 action
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okCtrl = [UIAlertAction actionWithTitle:okButtonTitle
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action){
                                                   }];
    //step 3 action
    [alertController addAction:okCtrl];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)privacyBtn {
    NSURL *url = [NSURL URLWithString:@"http://autobot.im/service_term.html"];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:safariVC animated:YES completion:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LoginTextInput *)phoneText {
    if (!_phoneText) {
        _phoneText = [[LoginTextInput alloc] initWithFrame:CGRectZero withType:LoginTextInputNormal];
        _phoneText.delegate = self;
        _phoneText.placeholder = @"请输入登录手机号";
        _phoneText.noSelectIc = @"shouji";
    }
    return _phoneText;
}

- (LoginTextInput *)pswText {
    if (!_pswText) {
        _pswText = [[LoginTextInput alloc] initWithFrame:CGRectZero withType:LoginTextInputPsw];
        _pswText.delegate = self;
        _pswText.placeholder = @"请输入密码";
        _pswText.noSelectIc = @"mima";
        _pswText.selectIc = @"116";
        _pswText.psw = YES;
    }
    return _pswText;
}

- (LoginButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[LoginButton alloc] init];
        [_loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.title = @"登录";
    }
    return _loginButton;
}

- (UIButton *)SMSlogin {
    if (!_SMSlogin) {
        _SMSlogin = [[UIButton alloc] init];
        [_SMSlogin setTitle:@"短信验证码登录" forState:UIControlStateNormal];
        [_SMSlogin addTarget:self action:@selector(SMSlogin:) forControlEvents:UIControlEventTouchUpInside];
        [_SMSlogin setTitleColor:[UIColor colorWithRed:52/255.0 green:126/255.0 blue:239/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_SMSlogin.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _SMSlogin.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _SMSlogin;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] init];
        [_registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(SMSregister:) forControlEvents:UIControlEventTouchUpInside];
        [_registerBtn setTitleColor:[UIColor colorWithRed:52/255.0 green:126/255.0 blue:239/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_registerBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _registerBtn;
}

- (ThirdPartLogin *)thirdPartLogin {
    if (!_thirdPartLogin) {
        _thirdPartLogin = [[ThirdPartLogin alloc] init];
    }
    return _thirdPartLogin;
}

- (NSMutableArray *)array {
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

- (UIButton *)privacy {
    if (!_privacy) {
        _privacy = [[UIButton alloc] init];
        NSMutableAttributedString*str = [[NSMutableAttributedString alloc]initWithString:@"注册或登录同意隐私条款"];
        NSRange strRange = {0,str.length};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]range:strRange];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkTextColor]  range:strRange];
        [_privacy setAttributedTitle:str forState:UIControlStateNormal];
//        [_privacy setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:@"123456" attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}] forState:UIControlStateNormal];
        _privacy.titleLabel.font = [UIFont systemFontOfSize:12];
        [_privacy addTarget:self action:@selector(privacyBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privacy;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backAction" object:nil];
}
@end
