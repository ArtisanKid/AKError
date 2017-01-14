//
//  AKError.m
//  Pods
//
//  Created by 李翔宇 on 16/6/15.
//
//

#import "AKError.h"
#import "AKErrorMacro.h"
#import "AKErrorManager.h"

@interface AKError ()

@end

@implementation AKError

- (instancetype)init {
    self = [super init];
    if(self) {
        if(AKError_environment && [AKError_environment conformsToProtocol:@protocol(AKEnvironmentProtocol)]) {
            if([AKError_environment respondsToSelector:@selector(dictionary)]) {
                _environment = [[AKError_environment dictionary] mutableCopy];
            }
        }
        
        if(AKError_user && [AKError_user conformsToProtocol:@protocol(AKEnvironmentProtocol)]) {
            if([AKError_user respondsToSelector:@selector(dictionary)]) {
                _user = [[AKError_user dictionary] mutableCopy];
            }
        }
    }
    return self;
}

#pragma mark- 属性方法
@synthesize extra = _extra;
- (NSMutableDictionary *)extra {
    if(!_extra) {
        _extra = [NSMutableDictionary dictionary];
    }
    return _extra;
}

- (void)setExtra:(NSMutableDictionary *)extra {
    if(![extra isKindOfClass:[NSDictionary class]]) {
        AKErrorLog(@"extra类型错误");
        return;
    }
    
    if([_extra isEqualToDictionary:extra]) {
        return;
    }
    
    if([extra isKindOfClass:[NSMutableDictionary class]]) {
        _extra = extra;
    } else {
        _extra = [extra mutableCopy];
    }
}

@synthesize user = _user;
- (NSMutableDictionary *)user {
    if(!_user) {
        _user = [NSMutableDictionary dictionary];
    }
    return _user;
}

- (void)setUser:(NSMutableDictionary *)user {
    if(![user isKindOfClass:[NSDictionary class]]) {
        AKErrorLog(@"user类型错误");
        return;
    }
    
    if([_user isEqualToDictionary:user]) {
        return;
    }
    
    if([user isKindOfClass:[NSMutableDictionary class]]) {
        _user = user;
    } else {
        _user = [user mutableCopy];
    }
}

- (NSString *)errorID {
    if(!_errorID.length) {
        _errorID = [@([NSDate date].timeIntervalSince1970) description];
    }
    return _errorID;
}

@synthesize environment = _environment;
- (NSMutableDictionary *)environment {
    if(!_environment) {
        _environment = [NSMutableDictionary dictionary];
    }
    return _environment;
}

- (void)setEnvironment:(NSMutableDictionary *)environment {
    if(![environment isKindOfClass:[NSDictionary class]]) {
        AKErrorLog(@"environment类型错误");
        return;
    }
    
    if([_environment isEqualToDictionary:environment]) {
        return;
    }
    
    if([environment isKindOfClass:[NSMutableDictionary class]]) {
        _environment = environment;
    } else {
        _environment = [environment mutableCopy];
    }
}

/**
 *  使用系统错误快速创建AKError
 *
 *  @param error NSError
 *
 *  @return id<AKErrorProtocol>
 */
+ (AKError<AKErrorProtocol> *)errorWithError:(NSError *)_error {
    AKError *error = [[AKError alloc] init];
    error.error = _error;
    return error;
}

/**
 *  使用系统异常快速创建AKError
 *
 *  @param error NSException
 *
 *  @return id<AKErrorProtocol>
 */
+ (AKError<AKErrorProtocol> *)errorWithException:(NSException *)exception {
    AKError *error = [[AKError alloc] init];
    error.exception = exception;
    return error;
}

/**
 *  快速创建AKError
 *
 *  @param extra id 业务参数
 *  @param alert NSString 用户提醒
 *  @param alert NSString 详情
 *
 *  @return id<AKErrorProtocol>
 */
+ (AKError<AKErrorProtocol> *)errorWithExtra:(NSDictionary * _Nullable)extra
                                alert:(NSString * _Nullable)alert
                               detail:(NSString * _Nullable)detail {
    AKError *error = [[AKError alloc] init];
    error.extra = [extra mutableCopy];
    error.alert = alert;
    return error;
}

- (NSString *)description {
    return [[self dictionary] description];
}

/**
 *  错误描述
 *
 *  @return NSDictionary
 */
- (NSDictionary *)dictionary {
    NSDictionary *err = @{ @"module" : @(self.module),
                           @"extra" : self.extra ? [self.extra copy] : @{},
                           @"alert" : self.alert ? self.alert : @"",
                           @"user" : self.user ? [self.user copy] : @{},
                           @"error" : self.error ? [self.error description] : @"",
                           @"exception" : self.exception ? [self.exception description] : @"",
                           @"errorID" : self.errorID ? self.errorID : @"",
                           @"domain" : @(self.domain),
                           @"subDomain" : @(self.subDomain),
                           @"code" : @(self.code),
                           @"subCode" : @(self.subCode),
                           @"detail" : self.detail ? self.detail : @"",
                           @"timestamp" : @(self.timestamp),
                           @"environment" : self.environment ? [self.environment copy] : @{} };
    return err;
}

/**
 *  错误描述
 *
 *  @return JSON
 */
- (NSString *)json {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(!data) {
        if(error) {
            AKErrorLog(@"Json序列化错误 error：%@", error);
        }
    }
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}

#pragma mark- Custom
static id<AKEUserProtocol> AKError_user = nil;
+ (void)setUser:(id<AKEUserProtocol>)user {
    AKError_user = user;
}

static id<AKEnvironmentProtocol> AKError_environment = nil;
+ (void)setEnvironment:(id<AKEnvironmentProtocol>)environment {
    AKError_environment = environment;
}

- (void)cache {
    [AKErrorManager cache:self];
}

- (void)upload {
    [AKErrorManager upload:self];
}

@end
