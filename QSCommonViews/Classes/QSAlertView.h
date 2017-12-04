//
//  QSAlertView.h
//  Pods-QSCommonViews_Example
//
//  Created by ZJ-Jie on 2017/12/1.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QSAlertButtonStyle) {
    QSAlertButtonStyleCancel,
    QSAlertButtonStyleImport,
    QSAlertButtonStyleNormal
};

@interface QSAlertButton : UIButton

+ (instancetype)createAlertButtonWithTitle:(NSString *)title action:(dispatch_block_t)action;

+ (instancetype)createAlertButtonWithTitle:(NSString *)title style:(QSAlertButtonStyle)style action:(dispatch_block_t)action;

@end

@interface QSAlertView : UIView

+ (instancetype)createAlertWithTitle:(NSString *)title message:(NSString *)message cancelButton:(QSAlertButton *)cancel otherButtons:(QSAlertButton *)otherButtons, ...;

- (void)show;

@end
