//
//  QSAlertViewsMacro.h
//  Pods
//
//  Created by ZJ-Jie on 2017/12/1.
//

#ifndef QSAlertViewsMacro_h
#define QSAlertViewsMacro_h

//屏幕信息
#define Screen_Bounds [UIScreen mainScreen].bounds
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Scale [UIScreen mainScreen].scale

//缩放比例
#define ratio2_scale (Screen_Width/375.f)
#define UIScale(x) ((x)*ratio2_scale)
#define UIScaleHeight(x) ((x)*Screen_Height/667.f)

// RGB颜色
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HEXRGBCOLOR(h)      RGBCOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define HEXRGBACOLOR(h,a)   RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)

#define kKeyWindow [UIApplication sharedApplication].keyWindow


#endif /* QSAlertViewsMacro_h */
