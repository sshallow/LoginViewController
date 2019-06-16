//
//  UIViewController+alert.m
//  AutoBotOS
//
//  Created by shangshuai on 2018/9/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIViewController+alert.h"

@implementation UIViewController (alert)

- (void)alert:(NSString *)alert {
    //STEP 1
    NSString *title = alert;
//    NSString *message = alert;
    NSString *okButtonTitle = @"好的";
    NSString *cancleTitle = @"取消";
    //step 2 action
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okCtrl = [UIAlertAction actionWithTitle:okButtonTitle
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action){
                                                       
                                                   }];
    UIAlertAction *Ctrl = [UIAlertAction actionWithTitle:cancleTitle
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action){
                                                 }];
    //step 3 action
//    [alertController addAction:Ctrl];
    [alertController addAction:okCtrl];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
