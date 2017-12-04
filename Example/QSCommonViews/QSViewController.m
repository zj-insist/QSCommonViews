//
//  QSViewController.m
//  QSCommonViews
//
//  Created by zj_lostself@163.com on 12/01/2017.
//  Copyright (c) 2017 zj_lostself@163.com. All rights reserved.
//

#import "QSViewController.h"
#import "QSCommonViews.h"

@interface QSViewController ()

@end

@implementation QSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(handleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleBtnEvent:(UIButton *)sender {
    [[QSAlertView createAlertWithTitle:@"测试" message:@"要多长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长长有多长多长多长" cancelButton:[QSAlertButton createAlertButtonWithTitle:@"取消" action:nil] otherButtons:[QSAlertButton createAlertButtonWithTitle:@"确定" action:^{
        sender.backgroundColor = [self randomColor];
    }],[QSAlertButton createAlertButtonWithTitle:@"确定" action:^{
        sender.backgroundColor = [self randomColor];
    }],[QSAlertButton createAlertButtonWithTitle:@"确定" action:^{
        sender.backgroundColor = [self randomColor];
    }],[QSAlertButton createAlertButtonWithTitle:@"确定" style:QSAlertButtonStyleImport action:^{
        sender.backgroundColor = [self randomColor];
    }],nil] show];
}

- (UIColor *) randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}



@end
