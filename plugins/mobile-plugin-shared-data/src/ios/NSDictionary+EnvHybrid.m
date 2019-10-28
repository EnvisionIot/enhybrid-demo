//
//  NSDictionary+EnvHybrid.m
//  Mydemo
//
//  Created by zhenghuiyu on 2019/4/19.
//
#import "NSDictionary+EnvHybrid.h"

@implementation NSDictionary (EnvHybrid)

- (id)objectForKeyIgnoreCase:(NSString *)key
{
    id value = [self objectForKey:key];
    if(!value){
        NSPredicate *searchPred=[NSPredicate predicateWithFormat:@"self LIKE[cd] %@", key];
        NSArray *searchedKeys=[[self allKeys] filteredArrayUsingPredicate:searchPred];
        if(searchedKeys.count>0){
            value =[self objectForKey:[searchedKeys objectAtIndex:0]];
        }
    }
    return value;
}

- (NSString *)convertToUTF8String
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if(!error){
        return  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else{
        return nil;
    }
}

@end
