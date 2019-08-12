//
//  WKWebView+Responder.m
//  Helloworld
//
//  Created by zhiyunyu on 2019/8/7.
//  Copyright © 2019 zhiyunyu. All rights reserved.
//

#import "WKWebView+Responder.h"

@implementation WKWebView (Responder)

- (BOOL)canPerformAction:(SEL)action withSender:(nullable id)sender {
    //  这样就可以轻松滴隐藏掉系统自带的菜单
    return NO;
}

- (void)share {
    NSLog(@"share 被点击");
}


@end
