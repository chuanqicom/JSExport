//
//  GFBWebProgressLayer.h
//  GFB
//
//  Created by 维信金科 on 2017/11/20.
//  Copyright © 2017年 Shanghai Aopai Data Technology Co., Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define  APPWIDTH  [UIScreen mainScreen].bounds.size.width
#define  APPHEIGHT [UIScreen mainScreen].bounds.size.height

// iPhone X 的适配
#define  SafeAreaTopHeight_NotNav (APPHEIGHT == 812.0 ? 24 : 0)
#define  SafeAreaTopHeight (APPHEIGHT == 812.0 ? 88 : 64)
#define  SafeAreaBottomHeight (APPHEIGHT == 812.0 ? 34 : 0)



typedef NS_ENUM(NSInteger,WebProgressStyle) {
    webProgressStyle_Normal, // 默认
    webProgressStyle_Gradual // 渐变
};

@interface GFBWebProgressLayerLoc : CAShapeLayer

@property (nonatomic, assign) WebProgressStyle progressStyle;
@property (nonatomic, strong) UIColor *progressColor;
/**
 进度条开始加载
 */
- (void)progressAnimationStart;

/**
 进度条加载完成
 */
- (void)progressAnimationCompletion;

@end
