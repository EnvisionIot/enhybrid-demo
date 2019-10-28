#import "EnvContextPlugin.h"
#define ENV_CONTEXT_SCRIPT  @"envcontext.js"

@implementation EnvContextPlugin
-(void)pluginInitialize
{
    [NSURLProtocol registerClass:[EnvContextURLProtocol class]];
}
@end


@implementation EnvContextURLProtocol
/**
 * @return 提供要写入envcontext.js的内容
 */
-(NSString * )contextScript
{
    NSString* urlBase ; // to do， 将后台服务器地址注入到window.navigator.serverAddress
    return [NSString stringWithFormat:@"window.navigator.serverAddress = '%@';", urlBase];
}

#pragma mark
#pragma mark NSURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest*)request
{
    NSURL* url = [request URL];
    if([url.absoluteString rangeOfString:ENV_CONTEXT_SCRIPT].location != NSNotFound){
        return YES;
    }else if([url.absoluteString rangeOfString:@"cordova_plugins.js"].location != NSNotFound){
        return YES;
    }else if ([url.absoluteString rangeOfString:@"cordova.js"].location != NSNotFound){
        return YES;
    }else if ([url.absoluteString rangeOfString:@"plugins/"].location != NSNotFound){
        return YES;
    }else if ([url.absoluteString rangeOfString:@"cordova-js-src/"].location != NSNotFound){
        return YES;
    }else if([url.absoluteString rangeOfString:@"raven.min.js.map"].location != NSNotFound){
        return YES;
    }else {
        return NO;
    }

}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request
{
    return request;
}

- (void)startLoading
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"www" ofType:nil];
    NSArray *arr = @[@"cordova_plugins.js",@"cordova.js",@"plugins/",@"cordova-js-src/",ENV_CONTEXT_SCRIPT];
    for (int i = 0 ; i< arr.count; i++) {
        NSUInteger start = [[self.request URL].absoluteString rangeOfString:arr[i]].location;
        NSData *data;
        if (start != NSNotFound && ![arr[i] isEqualToString:ENV_CONTEXT_SCRIPT]) {
            NSString *subUrl = [self.request.URL.absoluteString substringFromIndex:start];
            NSString *soursePath = [bundlePath stringByAppendingPathComponent:subUrl];
            data = [NSData dataWithContentsOfFile:soursePath];
        }else if (start != NSNotFound && [arr[i] isEqualToString:ENV_CONTEXT_SCRIPT]){
            data = [[self contextScript] dataUsingEncoding:NSUTF8StringEncoding];
        }
        if (data) {
                NSHTTPURLResponse* response = nil;
                NSDictionary * headersDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",data.length], @"Content-Length",@"application/javascript;charset=UTF-8",@"Content-Type",nil];
                response = [[NSHTTPURLResponse alloc] initWithURL:[self.request URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headersDict];
                
                [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowedInMemoryOnly];
                [self.client URLProtocol:self didLoadData:data];
                [self.client URLProtocolDidFinishLoading:self];
            break;
        }
    }
}

- (void)stopLoading
{
    
}
@end
