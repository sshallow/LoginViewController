//
//  ChangePswViewController.m
//  AutoBotOS
//
//  Created by shangshuai on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ChangePswViewController.h"
#import "LoginTextInput.h"
#import "NSString+MD5.h"
#import "LoginButton.h"
#import "AFNetworking/AFNetworking.h"
#import "Masonry/Masonry.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface ChangePswViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) LoginTextInput *oldText;

@property (nonatomic, strong) LoginTextInput *newText;

@property (nonatomic, strong) LoginTextInput *pswText;

@property (nonatomic, strong) LoginButton *loginButton;

@property (nonatomic, assign) BOOL isPsw;
@end

@implementation ChangePswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI {
    [self.view addSubview:self.oldText];
    [self.view addSubview:self.newText];
    [self.view addSubview:self.pswText];
    [self.view addSubview:self.loginButton];
    
    [self.oldText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(55);
        make.left.equalTo(self.view).with.offset(35);
        make.right.equalTo(self.view).with.offset(-35);
        make.height.mas_equalTo(@50);
    }];
    [self.newText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldText.mas_bottom).with.offset(30);
        make.left.equalTo(self.view).with.offset(35);
        make.right.equalTo(self.view).with.offset(-35);
        make.height.mas_equalTo(@50);
    }];
    [self.pswText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newText.mas_bottom).with.offset(30);
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
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@""]) return YES;
    if (textField.text.length >= 16) return NO;
    NSString *validRegEx =@"^[0-9]$";
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    return myStringMatchesRegEx;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

- (void)verOldPsw {
    NSString *md5 = [self.num md5:[NSString stringWithFormat:@"%@autobot$s$",self.num]];
    NSDictionary * parameter = @{@"phone":self.num,@"token":md5};
    NSString *oldmd5 = [self.oldText.text md5:[NSString stringWithFormat:@"%@",self.oldText.text]];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *baseUrl = [NSString stringWithFormat:@"http://54.222.213.58:5000/loginuser"];
    [SVProgressHUD showWithStatus:@"Loading..."];
    [mgr POST:baseUrl parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            if (dic[@"data"][@"passwd"]) {
                self.isPsw = YES;
                if (![oldmd5 isEqualToString:dic[@"data"][@"passwd"]]) {
                    [self alerWith:@"旧密码输入有误"];
                    return ;
                }
            } else {
                
            }
            if (self.newText.text.length < 6) {
                [self alerWith:@"密码不低于6位"];
                return ;
            }
            if (![self.newText.text isEqualToString:self.pswText.text]) {
                [self alerWith:@"新密码设置不一致,请重新输入"];
            } else if ([self.newText.text isEqualToString:self.oldText.text]) {
                [self alerWith:@"新密与旧密码一致,请重新输入"];
            } else {
                [self change];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.isPsw = NO;
        [SVProgressHUD dismiss];
    }];
}

- (void)change {
    NSString *md5 = [self.num md5:[NSString stringWithFormat:@"%@autobot$s$",self.num]];
    NSString *pswmd5 = [self.pswText.text md5:[NSString stringWithFormat:@"%@",self.pswText.text]];
    NSDictionary * parameter = @{@"phone":self.num,@"token":md5,@"passwd":pswmd5};
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *baseUrl = [NSString stringWithFormat:@"http://54.222.213.58:5000/updateprofile"];
    [SVProgressHUD showWithStatus:@"Loading..."];
    [mgr POST:baseUrl parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            [self alerWith:@"修改密码成功"];
        }else {
            [self alerWith:@"修改密码失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.isPsw = NO;
        [SVProgressHUD dismiss];
    }];
}

- (void)loginButton:(UIButton *)btn {
    [self verOldPsw];
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

- (LoginTextInput *)oldText {
    if (!_oldText) {
        _oldText = [[LoginTextInput alloc] initWithFrame:CGRectZero withType:LoginTextInputNormal];
        _oldText.delegate = self;
        _oldText.placeholder = @"请输入旧密码(未设置请忽略)";
        _oldText.noSelectIc = @"组5";
        _oldText.selectIc = @"116";
        _oldText.psw = YES;
    }
    return _oldText;
}

- (LoginTextInput *)newText {
    if (!_newText) {
        _newText = [[LoginTextInput alloc] initWithFrame:CGRectZero withType:LoginTextInputNormal];
        _newText.delegate = self;
        _newText.placeholder = @"请输入新密码";
        _newText.noSelectIc = @"组5";
        _newText.selectIc = @"116";
        _newText.psw = YES;
    }
    return _newText;
}

- (LoginTextInput *)pswText {
    if (!_pswText) {
        _pswText = [[LoginTextInput alloc] initWithFrame:CGRectZero withType:LoginTextInputNormal];
        _pswText.delegate = self;
        _pswText.placeholder = @"请再次输入新密码";
        _pswText.noSelectIc = @"组5";
        _pswText.selectIc = @"116";
        _pswText.psw = YES;
    }
    return _pswText;
}

- (LoginButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[LoginButton alloc] init];
        [_loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.title = @"确认修改";
    }
    return _loginButton;
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
