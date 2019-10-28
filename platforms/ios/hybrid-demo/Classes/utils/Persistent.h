//
//  Persistent.h
//  HEMS
//
//  Created by HMac on 2016/12/29.
//
//

#import <Foundation/Foundation.h>

@interface Persistent : NSObject

+ (BOOL)writeToFile:(NSString *)fileName content:(NSDictionary *)content;

+ (NSDictionary *)readFromFile:(NSString *)fileName;

+ (void)removeFile:(NSString*)fileName;
@end
