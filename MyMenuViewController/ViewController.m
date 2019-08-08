//
//  ViewController.m
//  MyMenuViewController
//
//  Created by zhiyunyu on 2019/8/7.
//  Copyright © 2019 zhiyunyu. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#define CHECK_VALID_ARRAY(__aArray) (__aArray && [__aArray isKindOfClass:[NSArray class]] && [__aArray count])


@interface ViewController ()<WKUIDelegate, WKNavigationDelegate>
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) UIMenuController *menuController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration =[[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://view.inews.qq.com/a/20190726A0S73500?uid=100146243534&shareto=wx"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [self.webView loadRequest:request];
    
    [self setMenu];
}

- (void)setMenu {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:[self contextMenuItems]];
    [menuController setMenuVisible:NO];
    
    self.menuController = [UIMenuController sharedMenuController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowMenu:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didShowMenu:)
                                                 name:UIMenuControllerDidShowMenuNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHideMenu:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didHideMenu:)
                                                 name:UIMenuControllerDidHideMenuNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuFrameDidChanged:)
                                                 name:UIMenuControllerMenuFrameDidChangeNotification
                                               object:nil];

}

// 这是一种在 wkwebview 中隐藏系统自带菜单的方法，也可以通过css属性来控制隐藏，具体原理我们可以晚会儿再理解 https://answer-id.com/62347732

- (void)willShowMenu:(NSNotification *)notification {
    NSLog(@"willShowMenu");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"[self.menuController setMenuVisible:NO];");
        [self.menuController setMenuVisible:NO];
    });
}

- (void)didShowMenu:(NSNotification *)notification {
    NSLog(@"didShowMenu");
}

- (void)willHideMenu:(NSNotification *)notification {
   NSLog(@"willHideMenu");
}

- (void)didHideMenu:(NSNotification *)notification {
    NSLog(@"didHideMenu");
    NSLog(@"menuframe = %@, visible = %@", @(_menuController.menuFrame), @(_menuController.menuVisible));
}

- (void)menuFrameDidChanged:(NSNotification *)notification {
    NSLog(@"menuFrameDidChanged");
    
    NSLog(@"menuframe = %@", @([self.menuController menuFrame]));
}


- (NSArray*)contextMenuItems {
    static NSArray* menuItems;
    if (!CHECK_VALID_ARRAY(menuItems)) {
        NSArray* data = @[
                          @[@"分享", @"share"],                 //分享
                          ];
        NSMutableArray* items = [NSMutableArray array];
        
        for (NSArray* pair in data) {
            NSString* title = pair[0];
            NSString* selector = pair[1];
            UIMenuItem* menuItem = [[UIMenuItem alloc] initWithTitle:title action:NSSelectorFromString(selector)];
            [items addObject:menuItem];
        }
        menuItems = items;
    }
    return menuItems;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    //拦截百度页面
    if ([url.absoluteString containsString:@"baidu"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


@end
