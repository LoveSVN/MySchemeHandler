//
//  MySchemeHandler.m
//  html1
//
//  Created by Mac on 2023/4/10.
//

#import "MySchemeHandler.h"
#import <CoreServices/CoreServices.h>

@implementation MySchemeHandler

- (NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}

- (void)webView:(nonnull WKWebView *)webView startURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask {

    

    NSLog(@"拦截到请求的URL：%@", urlSchemeTask.request.URL);
    NSString *localFileName = [urlSchemeTask.request.URL lastPathComponent];
    
    if([localFileName isEqualToString:@"dongbeiLog.php"]){
        
        NSURLSessionDataTask *session = [[NSURLSession sharedSession] dataTaskWithRequest:urlSchemeTask.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            [urlSchemeTask didReceiveResponse:response];
            [urlSchemeTask didReceiveData:data];
            [urlSchemeTask didFinish];
        }];
        [session resume];
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSData *data = [html dataUsingEncoding:4];
    NSString *fileMIME = [self getMIMETypeWithCAPIAtFilePath:path];
    NSDictionary *responseHeader = @{
                                     @"Content-type":fileMIME,
                                     @"Content-length":[NSString stringWithFormat:@"%lu",(unsigned long)[data length]]
                                     };
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"myScheme://myScheme.test.cn/", @"index.html"]] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];
    [urlSchemeTask didReceiveResponse:response];
    [urlSchemeTask didReceiveData:data];
    [urlSchemeTask didFinish];
}

- (void)webView:(nonnull WKWebView *)webView stopURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask {
    
    NSLog(@"%@",urlSchemeTask);
}
@end
