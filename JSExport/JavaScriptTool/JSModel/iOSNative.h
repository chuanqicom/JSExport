//
//  iOSNative.h
//  JavaScriptAndObjectiveC
//
//  Created by 维信金科 on 17/2/27.
//  Copyright © 2017年 Shanghai Aopai Data Technology Co., Ltd. All rights reserved.
//

/**
 *  JS - OC 协议类 使用方法:
 *  iOS 中 webViewDidFinishLoad:(UIWebView *)webView 方法中;
 *
 *  iOS_Native *native  = [[iOS_Native alloc] initWithWebView:webView];
 *  native.jsContext[@"iOSNative"] = native;
 *
 *  JS 中
 *  <input type="button" value="Call ObjC system camera" onclick="iOSNative.callSystemCamera()">
 *
 */
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JS_OCDelegate <JSExport>

#pragma mark - JS -> OC

// JS调用此方法来调用OC的系统相册方法
- (void)callSystemCamera;
// 在JS中调用时，函数名应该为showAlertMsg(arg1, arg2)
// 这里是只两个参数的。
// （写法一：）
// - (void)showAlert:(NSString *)title msg:(NSString *)msg;
//  (写法二：)
JSExportAs(showAlert, - (void)showAlert:(NSString *)title msg:(NSString *)msg);

// 通过JSON传过来
- (void)callWithDict:(NSDictionary *)params;
// JS调用Oc，然后在OC中通过调用JS方法来传值给JS。
- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params;

#pragma mark - OC -> JS

/**
 *  OC调用JS example:
 *  [native ocCallJSWithString:@"alert('OC调用JS');"];
 */
- (void)OCCallJSWithString:(NSString *)jsStr;

/**
 获取Webview的标题

 @param jsStr JS代码
 @return 标题 example:    [native getTitleWithJSString:@"document.title"];
 */
- (NSString *)getTitleWithJSString:(NSString *)jsStr;
- (void)OCCallJSWithFunString:(NSString *)jsFun andArguments:(NSArray*)arguments;

@end


#pragma mark - iOS_NativeDelegate
#warning ******* 代理如果渲染UI,一定要回到主线程! *******
@protocol iOSNativeDelegate <NSObject>
@optional

@end

@interface iOSNative : NSObject <JS_OCDelegate>

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, weak) id <iOSNativeDelegate>delegate;

- (instancetype)initWithWebView:(UIWebView *)webView;

/**
 *  获取异常信息 example:
    native.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
 */
- (void)iOSNativeExceptionHandlerBlock:(void(^)(JSContext *context, JSValue *exceptionValue))exceptionHandlerBlock;


@end
