//
//  AKErrorProtocol.h
//  Pods
//
//  Created by 李翔宇 on 16/6/15.
//
//

#import <Foundation/Foundation.h>
#import "AKEnvironmentProtocol.h"

typedef NS_ENUM(NSUInteger, AKErrorDomain) {
    AKErrorDomainNull = 0,
    AKErrorDomainUI = 1,/**<视图*/
    AKErrorDomainNetwork,/**<网络*/
    AKErrorDomainDatabase,/**<数据库*/
    AKErrorDomainFile,/**<文件*/
    AKErrorDomainLocation/**<定位*/
};

NS_ASSUME_NONNULL_BEGIN

@protocol AKErrorProtocol <NSObject>

/**
 *  业务模块
 */
@property (nonatomic, assign) NSUInteger module;

/**
 *  业务参数
 */
@property (nonatomic, strong) id extra;

/**
 *  用户提醒
 */
@property (nonatomic, copy) NSString *alert;

/**
 *  用户
 */
@property (nonatomic, strong) id user;

///////////////////////////////////////////////////////////////////

/**
 *  系统错误，NSError
 */
@property (nonatomic, strong) id error;

/**
 *  系统异常, NSException
 */
@property (nonatomic, strong) id exception;

/**
 *  ID
 */
@property (nonatomic, copy) NSString *errorID;

/**
 *  功能域
 */
@property (nonatomic, assign) AKErrorDomain domain;

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
@property (nonatomic, strong) id environment;

///////////////////////////////////////////////////////////////////

/**
 *  使用系统错误快速创建AKError
 *
 *  @param error NSError
 *
 *  @return id<AKErrorProtocol>
 */
+ (id<AKErrorProtocol>)errorWithError:(NSError *)error;

/**
 *  使用系统异常快速创建AKError
 *
 *  @param error NSException
 *
 *  @return id<AKErrorProtocol>
 */
+ (id<AKErrorProtocol>)errorWithException:(NSException *)exception;

/**
 *  快速创建AKError
 *
 *  @param extra id 业务参数
 *  @param alert NSString 用户提醒
 *  @param alert NSString 详情
 *
 *  @return id<AKErrorProtocol>
 */
+ (id<AKErrorProtocol>)errorWithExtra:(id _Nullable)extra
                                alert:(NSString * _Nullable)alert
                               detail:(NSString * _Nullable)detail;


@optional

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

@end

NS_ASSUME_NONNULL_END
