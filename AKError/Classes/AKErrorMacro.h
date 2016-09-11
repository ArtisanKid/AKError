//
//  AKErrorMacro.h
//  Pods
//
//  Created by 李翔宇 on 16/7/11.
//
//

#import <Foundation/Foundation.h>

#ifndef AKErrorMacro_h
#define AKErrorMacro_h

static BOOL AKErrorLogState = YES;

#define AKErrorLogFormat(INFO, ...) [NSString stringWithFormat:(@"\n[Date:%s]\n[Time:%s]\n[File:%s]\n[Line:%d]\n[Function:%s]\n" INFO @"\n"), __DATE__, __TIME__, __FILE__, __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__] 

#if DEBUG
    #define AKErrorLog(INFO, ...) !AKErrorLogState ? : NSLog((@"\n[Date:%s]\n[Time:%s]\n[File:%s]\n[Line:%d]\n[Function:%s]\n" INFO @"\n"), __DATE__, __TIME__, __FILE__, __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__);
#else
    #define AKErrorLog(INFO, ...)
#endif

#define AKObjectToJSON \
+ (NSString *)objectToJSON:(id)obj {\
    NSError *error = nil;\
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];\
    if(!data) {\
        if(error) {\
            AKErrorLog(@"Json序列化错误 error：%@", error);\
        }\
    }\
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];\
    return json;\
}\

#define AKJSONToObject \
+ (id)jsonToObject:(NSString *)json {\
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];\
    NSError *error = nil;\
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];\
    if(!object) {\
        if(error) {\
            AKErrorLog(@"Json反序列化错误 error：%@", error);\
        }\
    }\
    return object;\
}\

#endif /* AKErrorMacro_h */
