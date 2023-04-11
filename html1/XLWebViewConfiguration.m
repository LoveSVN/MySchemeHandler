//
//  XLWebViewConfiguration.m
//  html1
//
//  Created by Mac on 2023/4/11.
//

#import "XLWebViewConfiguration.h"
#import "CaptainHook/CaptainHook.h"

@implementation XLWebViewConfiguration

+(void)load{
    
}
@end


CHDeclareClass(WKWebView)
CHClassMethod1(BOOL, WKWebView, handlesURLScheme, NSString *, urlScheme) {
    
    if([urlScheme isEqualToString:@"myScheme"] || [urlScheme isEqualToString:@"http"] || [urlScheme isEqualToString:@"https"]) {
        
        return NO;
    }
    
    return YES;
}
__attribute__((constructor())) static void entry3() {
    
//   写到 XLWebViewConfiguration load 也可
    CHLoadLateClass(WKWebView);
    CHClassHook1(WKWebView, handlesURLScheme);
}
