//
//  ViewController.m
//  html1
//
//  Created by Mac on 2023/4/4.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "MySchemeHandler.h"
#import "XLWKWebView.h"
@interface ViewController ()
@property (strong, nonatomic) WKWebView *webView;
@property(nonatomic,strong)MySchemeHandler *webHandler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webHandler = [[MySchemeHandler alloc] init];
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"myScheme://myScheme.test.cn/index.html"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0f];
    [webViewConfiguration setURLSchemeHandler:self.webHandler forURLScheme:@"myScheme"];
    [webViewConfiguration setURLSchemeHandler:self.webHandler forURLScheme:@"http"];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webViewConfiguration];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    
}

@end
