//
//  AKError.h
//  Pods
//
//  Created by 李翔宇 on 16/6/15.
//
//

#import <Foundation/Foundation.h>
#import "AKErrorProtocol.h"
#import "AKEnvironmentProtocol.h"
#import "AKEUserProtocol.h"

typedef NS_ENUM(NSUInteger, AKErrorModule) {
    AKErrorModuleNone = 0,
};

NS_ASSUME_NONNULL_BEGIN

@interface AKError : NSObject<AKErrorProtocol>

/**
 *  业务模块
 */
@property (nonatomic, assign) AKErrorModule module;

/**
 *  业务参数
 */
@property (nonatomic, strong) NSMutableDictionary *extra;

/**
 *  用户提醒
 */
@property (nonatomic, copy) NSString *alert;

/**
 *  用户
 */
@property (nonatomic, strong) NSMutableDictionary *user;

///////////////////////////////////////////////////////////////////

/**
 *  系统错误
 */
@property (nonatomic, strong) NSError *error;

/**
 *  系统异常
 */
@property (nonatomic, strong) NSException *exception;

/**
 *  ID
 */
@property (nonatomic, copy) NSString *errorID;

/**
 *  功能域
 */
@property (nonatomic, assign) AKErrorDomain domain;

/**
 *  功能子域
 */
@property (nonatomic, assign) AKErrorSubDomain subDomain;

/**
 *  错误码
 */
@property (nonatomic, assign) NSUInteger code;

/**
 *  错误子码
 */
@property (nonatomic, assign) NSUInteger subCode;

/**
 *  详情
 */
@property (nonatomic, copy) NSString *detail;

/**
 *  时间戳
 */
@property (nonatomic, assign) NSTimeInterval timestamp;

/**
 *  环境
 */
@property (nonatomic, strong) NSMutableDictionary *environment;

///////////////////////////////////////////////////////////////////

/**
 *  使用系统错误快速创建AKError
 *
 *  @param error NSError
 *
 *  @return id<AKErrorProtocol>
 */
+ (AKError<AKErrorProtocol> *)errorWithError:(NSError *)error;

/**
 *  使用系统异常快速创建AKError
 *
 *  @param error NSException
 *
 *  @return id<AKErrorProtocol>
 */
+ (AKError<AKErrorProtocol> *)errorWithException:(NSException *)exception;

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
                               detail:(NSString * _Nullable)detail;

/**
 *  错误描述
 *
 *  @return NSDictionary
 */
- (NSDictionary *)dictionary;

/**
 *  错误描述
 *
 *  @return JSON
 */
- (NSString *)json;

#pragma mark- Custom
/**
 *  设置默认User
 *
 *  @param user id<AKEUserProtocol>
 */
+ (void)setUser:(id<AKEUserProtocol>)user;

/**
 *  设置默认Environment
 *
 *  @param user id<AKEnvironmentProtocol>
 */
+ (void)setEnvironment:(id<AKEnvironmentProtocol>)environment;

/**
 *  缓存至本地
 */
- (void)cache;

/**
 *  上传
 */
- (void)upload;

@end

NS_ASSUME_NONNULL_END
