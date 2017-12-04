//
//  QSAlertView.m
//  Pods-QSCommonViews_Example
//
//  Created by ZJ-Jie on 2017/12/1.
//

#import "QSAlertView.h"
#import "UIView+Tools.h"
#import "QSAlertViewsMacro.h"

#define QSAlertViewMaxHeight (Screen_Height * 0.6)

static CGFloat const QSAlertViewCustomPadding = 20;
static CGFloat const QSAlertViewMinHeight = 103;
static CGFloat const QSAlertBtnHeight = 45;

static NSString * const QSAlerthandleButton = @"QSAlerthandleButton";

@interface QSAlertButton()

@property(nonatomic, assign) QSAlertButtonStyle style;
@property(nonatomic, copy) dispatch_block_t action;

@end

@implementation QSAlertButton

+ (instancetype)createAlertButtonWithTitle:(NSString *)title action:(dispatch_block_t)action {
    return [QSAlertButton createAlertButtonWithTitle:title style:QSAlertButtonStyleNormal action:action];
}

+ (instancetype)createAlertButtonWithTitle:(NSString *)title style:(QSAlertButtonStyle)style action:(dispatch_block_t)action {
    QSAlertButton *btn = [QSAlertButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.style = style;
    btn.action = action;
    
    return btn;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:UIScale(16)]];
        [self setBackgroundImage:[QSAlertButton createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(handleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setStyle:(QSAlertButtonStyle)style {
    UIColor *titleColor = HEXRGBCOLOR(0x333333);
    switch (style) {
        case QSAlertButtonStyleCancel:
        {
            titleColor = HEXRGBCOLOR(0x999999);
            break;
        }
        case QSAlertButtonStyleImport:
        {
            titleColor = HEXRGBCOLOR(0xF1502B);
            break;
        }
        default:
            break;
    }
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)handleBtnEvent:(id)sender {
    if (self.action) {
        self.action();
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:QSAlerthandleButton object:nil];
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end

@interface QSAlertView()
@property(nonatomic, strong) UIView *alertView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextView *messageTextView;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UIView *btnsView;

@end

@implementation QSAlertView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)createAlertWithTitle:(NSString *)title message:(NSString *)message cancelButton:(QSAlertButton *)cancel otherButtons:(QSAlertButton *)otherButtons, ... {
    
    if ((!title || !title.length)&& (!message || !message.length)) return nil;
    
    //获取加入的其他Button
    NSMutableArray *buttonsArray = [NSMutableArray array];
    
    if (cancel) {
        cancel.style = QSAlertButtonStyleCancel;
        [buttonsArray addObject:cancel];
    }
    
    QSAlertButton *eachItem;
    va_list argumentList;
    if (otherButtons) {
        [buttonsArray addObject:otherButtons];
        va_start(argumentList, otherButtons);
        while((eachItem = va_arg(argumentList, QSAlertButton *))) {
            [buttonsArray addObject: eachItem];
        }
        va_end(argumentList);
    }
    //限制最多9个按钮
    if (buttonsArray.count > 9) {
        buttonsArray = [[buttonsArray subarrayWithRange:NSMakeRange(0, 9)] mutableCopy];
    }
    CGFloat btnHeight = [QSAlertView getButtonViewHeightWithCount:buttonsArray.count];
    
    QSAlertView *alert = [QSAlertView new];

    CGFloat offset = QSAlertViewCustomPadding;
    alert.titleLabel.hidden = !(title && title.length);
    offset = offset + ((title && title.length) ? 30 : 0);
    
    CGSize messageSize = [QSAlertView getSizeWithText:message fontSize:UIScale(16) maxSize:CGSizeMake(UIScale(290 - 40), MAXFLOAT)];
    CGFloat messageHeight = messageSize.height;
    CGFloat alertHeight = QSAlertViewMinHeight + btnHeight;
    
    CGFloat messageMinHeight = QSAlertViewMinHeight - offset - QSAlertViewCustomPadding;
    if (messageSize.height < messageMinHeight) {
        messageHeight = messageSize.height;
    } else if (messageSize.height >= messageMinHeight && messageSize.height < QSAlertViewMaxHeight - btnHeight - messageMinHeight) {
        messageHeight = messageSize.height;
        alertHeight = offset + messageHeight + QSAlertViewCustomPadding + btnHeight;
    } else {
        messageHeight = QSAlertViewMaxHeight - offset - QSAlertViewCustomPadding - btnHeight;
        alertHeight = QSAlertViewMaxHeight;
    }
    
    //设置Alert位置和大小
    alert.alertView.height = alertHeight;
    alert.alertView.center = CGPointMake(kKeyWindow.width/2, kKeyWindow.height/2);
    
    alert.titleLabel.left = QSAlertViewCustomPadding;
    alert.titleLabel.top = QSAlertViewCustomPadding;
    
    alert.messageTextView.size = CGSizeMake(messageSize.width, messageHeight);
    alert.messageTextView.centerX = UIScale(290)/2;
    alert.messageTextView.top = offset;
    
    if (!title || !title.length) {
        alert.messageTextView.centerY = QSAlertViewMinHeight / 2;
    }
    
    if (!message || !message.length) {
        alert.titleLabel.centerY = QSAlertViewMinHeight / 2;
    }
    
    alert.lineView.bottom = alertHeight - btnHeight;
    
    alert.btnsView.top = alert.lineView.bottom;
    alert.btnsView.height = btnHeight;
    
    [alert.titleLabel setText:title];
    [alert.messageTextView setText:message];
    
    if (buttonsArray.count < 1) {
        __weak __typeof(alert)weakAlert = alert;
        QSAlertButton *btn = [QSAlertButton createAlertButtonWithTitle:@"确定" action:^{
            __strong __typeof(weakAlert)strongAlert = weakAlert;
            [strongAlert disMiss];
        }];
        btn.size = [QSAlertView getButtonSizeWithCount:0];
        btn.origin = [QSAlertView getButtonOriginPointWithIndex:0 btnSize:btn.size count:0];
        btn.tag = 0;
        [alert.btnsView addSubview:btn];
    } else {
        [buttonsArray enumerateObjectsUsingBlock:^(QSAlertButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.size = [QSAlertView getButtonSizeWithCount:buttonsArray.count];
            obj.origin = [QSAlertView getButtonOriginPointWithIndex:idx btnSize:obj.size count:buttonsArray.count];
            obj.tag = idx;
            [alert.btnsView addSubview:obj];
            [alert setupBtn:obj index:idx count:buttonsArray.count];
        }];
    }
    
    return alert;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = kKeyWindow.bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self setupSubViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disMiss) name:QSAlerthandleButton object:nil];
    }
    return self;
}

- (void)setupSubViews {
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScale(290), 0)];
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 4;
    _alertView.layer.masksToBounds = YES;
    [self addSubview:_alertView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIScale(290 - 40), 30)];
    [_titleLabel setFont:[UIFont systemFontOfSize:UIScale(18)]];
    [_titleLabel setTextColor:HEXRGBCOLOR(0x333333)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:_titleLabel];
    
    _messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, UIScale(290 - 40), 0)];
    [_messageTextView setFont:[UIFont systemFontOfSize:UIScale(16)]];
    [_messageTextView setTextColor:HEXRGBCOLOR(0x333333)];
    _messageTextView.textAlignment = NSTextAlignmentCenter;
    _messageTextView.textContainer.lineFragmentPadding = 0;
    _messageTextView.textContainerInset = UIEdgeInsetsZero;
    _messageTextView.editable = NO;
    _messageTextView.bounces = NO;
    [_alertView addSubview:_messageTextView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, 0.5)];
    _lineView.backgroundColor = HEXRGBCOLOR(0xEBEBEB);
    [_alertView addSubview:_lineView];
    
    _btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, 0)];
    [_alertView addSubview:_btnsView];
}

- (void)show {
    [kKeyWindow addSubview:self];
}

- (void)disMiss {
    [self removeFromSuperview];
}

- (void)setupBtn:(QSAlertButton *)btn index:(NSInteger)index count:(NSInteger)count {
    if (count < 2) return;
    NSInteger rowNum = 2;
    switch (count) {
        case 2:
        case 4:
            rowNum = 2;
            break;
        default:
            rowNum = 3;
            break;
    }
    
    if (ceil(index/rowNum) < ceil((count - 1)/rowNum)) {
        UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.width, 0.5)];
        rowLine.backgroundColor = HEXRGBCOLOR(0xEBEBEB);
        [self.btnsView addSubview:rowLine];
        rowLine.left = btn.left;
        rowLine.bottom = btn.bottom;
        btn.height = btn.height - 0.5;
    }
    
    if (index % rowNum != (rowNum - 1)) {
        UIView *colLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, btn.height)];
        colLine.backgroundColor = HEXRGBCOLOR(0xEBEBEB);
        [self.btnsView addSubview:colLine];
        colLine.top = btn.top;
        colLine.right = btn.right;
        btn.width = btn.width - 0.5;
    }
}

+ (CGSize)getSizeWithText:(NSString *)text fontSize:(CGFloat)font maxSize:(CGSize)maxSize {
    if (!text.length) {
        return CGSizeZero;
    }
    CGSize size = [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.height = ceilf(size.height);
    return size;
}

+ (CGFloat)getButtonViewHeightWithCount:(NSInteger)count {
    switch (count) {
        case 0:
        case 1:
        case 2:
        case 3:
            return QSAlertBtnHeight;
        default:
            return ceil(count/3.0) * QSAlertBtnHeight;
    }
}

+ (CGSize)getButtonSizeWithCount:(NSInteger)count {
    switch (count) {
        case 0:
        case 1:
            return CGSizeMake(UIScale(290), QSAlertBtnHeight);
        case 2:
        case 4:
            return CGSizeMake(UIScale(290)/2, QSAlertBtnHeight);
        default:
            return CGSizeMake(UIScale(290)/3, QSAlertBtnHeight);
    }
}

+ (CGPoint)getButtonOriginPointWithIndex:(NSInteger)index btnSize:(CGSize)btnSize count:(NSInteger)count {
    switch (count) {
        case 0:
        case 1:
            return CGPointMake(0, 0);
        case 2:
        case 4:
            return CGPointMake((index % 2) * btnSize.width, floor(index/2) * btnSize.height);
        default:
            return CGPointMake((index % 3) * btnSize.width, floor(index/3) * btnSize.height);
    }
}



@end
