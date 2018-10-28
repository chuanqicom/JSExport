//
//  iOSNative.m
//  JavaScriptAndObjectiveC
//
//  Created by 维信金科 on 17/2/27.
//  Copyright © 2017年 Shanghai Aopai Data Technology Co., Ltd. All rights reserved.
//

#import "iOSNative.h"

@implementation iOSNative

- (instancetype)initWithWebView:(UIWebView *)webView{
    if (self = [super init]) {
        self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    return self;
}

#pragma mark -
#pragma mark -------------------- JS -> OC -------------------

- (void)callWithDict:(NSDictionary *)params {
    NSLog(@"Js调用了OC的方法，参数为：%@", params);
}

// Js调用了callSystemCamera
- (void)callSystemCamera {
    NSLog(@"JS调用了OC的方法，调起系统相册");
    
    // JS调用后OC后，又通过OC调用JS，但是这个是没有传参数的
    [self OCCallJSWithFunString:@"jsFunc" andArguments:nil];
}

- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params {
    NSLog(@"jsCallObjcAndObjcCallJsWithDict was called, params is %@", params);
    
    // 调用JS的方法
    [self OCCallJSWithFunString:@"jsParamFunc" andArguments:@[@{@"age": @10, @"name": @"John", @"height": @158}]];
}

/**
 *  JS调用OC方法
 */
- (void)showAlert:(NSString *)title msg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [a show];
    });
}

#pragma mark -
#pragma mark -------------------- OC - JS -------------------

/**
 *  OC调用JS方法 没有参数
 */
- (void)OCCallJSWithString:(NSString *)jsStr{
    [self.jsContext evaluateScript:jsStr];
}

/**
 *  OC调用JS方法 有参数
 */
- (void)OCCallJSWithFunString:(NSString *)jsFun andArguments:(NSArray*)arguments{
    JSValue *jsParamFunc = self.jsContext[jsFun];
    [jsParamFunc callWithArguments:arguments];
}


/**
 *  OC调用JS方法 有返回值
 */
- (NSString *)getTitleWithJSString:(NSString *)jsStr{
    JSValue *jsValue = [self.jsContext evaluateScript:jsStr];
    
    return [jsValue toString];
}


#pragma mark -
#pragma mark ------------------- 获取错误信息 -------------------

- (void)iOSNativeExceptionHandlerBlock:(void(^)(JSContext *context, JSValue *exceptionValue))exceptionHandlerBlock{
    
    if (exceptionHandlerBlock) {
        self.jsContext.exceptionHandler = exceptionHandlerBlock;
    }
}

@end
