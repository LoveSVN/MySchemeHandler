//
//  XLWKWebView.m
//  html1
//
//  Created by Mac on 2023/4/11.
//

#import "XLWKWebView.h"
#import <objc/runtime.h>






@implementation XLWKWebView

+(void)load {
    
    
    
}

+ (void)swizzleInstanceMethod:(SEL)originalSel with:(SEL)swizzledSel {

    
    
   
    Method originalMethod = class_getInstanceMethod(NSClassFromString(@"WKWebView"), originalSel);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSel);
    IMP originalIPM = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    

    
    NSString *TSTBaseWKWebVC_original_real_sel  = [NSString stringWithFormat:@"%@_real_%@",NSStringFromClass([self class]),NSStringFromSelector(originalSel)];
     
    //做个容错
    BOOL hasReal_sel = class_addMethod([self class], NSSelectorFromString(TSTBaseWKWebVC_original_real_sel), originalIPM, method_getTypeEncoding(originalMethod));
    
    IMP TSTBaseWKWebVC_original_real_IMP = class_getMethodImplementation([self class], NSSelectorFromString(TSTBaseWKWebVC_original_real_sel));
    
    
    NSString *TSTBaseWKWebVC_swizzled_real_sel  = [NSString stringWithFormat:@"%@_real_%@",NSStringFromClass([self class]),NSStringFromSelector(swizzledSel)];
     
    class_addMethod([self class], NSSelectorFromString(TSTBaseWKWebVC_swizzled_real_sel), swizzledIMP, method_getTypeEncoding(swizzledMethod));
    IMP TSTBaseWKWebVC_swizzled_real_IMP = class_getMethodImplementation([self class], NSSelectorFromString(TSTBaseWKWebVC_swizzled_real_sel));
    
    
    BOOL didAddMethod =
    class_addMethod(self,
                    originalSel,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            swizzledSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);

    }
    
}

+(BOOL)handlesURLScheme:(NSString *)urlScheme {
    
    if([urlScheme isEqualToString:@"herald-hybrid"] || [urlScheme isEqualToString:@"http"] || [urlScheme isEqualToString:@"https"]) {
        
        return NO;
    }
    
    return YES;
}

@end
