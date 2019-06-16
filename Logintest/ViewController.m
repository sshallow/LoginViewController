//
//  ViewController.m
//  Logintest
//
//  Created by apple on 2019/6/16.
//  Copyright © 2019 Anti-wolf. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 214, 214)];
    btn.backgroundColor = [UIColor grayColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn setTitle:@"按钮标题" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)btnClick:(UIButton *)sender {
    NSLog(@"**********点击按钮**********");
    LoginViewController *vc = [[LoginViewController alloc]init];
    vc.title = @"登录";
    [self presentViewController:vc animated:YES completion:nil];
}

@end
