//
//  Persistent.m
//  HEMS
//
//  Created by HMac on 2016/12/29.
//
//

#import "Persistent.h"

@implementation Persistent

+ (BOOL)writeToFile:(NSString *)fileName content:(NSDictionary *)content{
    
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *filePath = [path stringByAppendingPathComponent:fileName];

    //序列化-存入文件
    NSError *error = nil;
    BOOL result = [content writeToFile:filePath atomically:YES];
    if (result) {
        NSLog(@"写入成功");
    } else {
        NSLog(@"写入失败：%@", error);
    }
    
    return result;
}

+ (NSDictionary *)readFromFile:(NSString *)fileName{
    
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    //反序列化，把文件数据读取出来
    NSError *errror = nil;
    NSDictionary *content = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    if (!errror) {
        NSLog(@"读出成功");
    } else {
        NSLog(@"读出失败： %@", errror);
    }
    
    return content;
    
}

+ (void)removeFile:(NSString *)fileName{
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager* fileManager=[NSFileManager defaultManager];

    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!blHave) {
        NSLog(@"%@ not exsited", fileName);
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            NSLog(@"delete %@ success", filePath);
        }else {
            NSLog(@"delete %@ fail", filePath);
        }
    }
    
}

@end
