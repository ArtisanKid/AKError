//
//  AKErrorManager.h
//  Pods
//
//  Created by 李翔宇 on 16/9/7.
//
//

#import <Foundation/Foundation.h>
#import "AKErrorProtocol.h"

typedef NS_ENUM(NSUInteger, AKErrorUploadWhen) {
    AKErrorUploadWhenNever,
    AKErrorUploadWhenFinishLaunching,
    AKErrorUploadWhenBecomeActive,
    AKErrorUploadWhenEnterBackground
};

typedef BOOL(^AKErrorUploadBlock)(NSArray<NSDictionary *> *errors);

NS_ASSUME_NONNULL_BEGIN

@interface AKErrorManager : NSObject

/**
 *  设置上传uploadBlock。会在各个线程中调用。上传任何错误都不考虑上传失败的问题
 *
 *  @param uploadBlock AKErrorUploadBlock
 */
+ (void)setUploadBlock:(AKErrorUploadBlock)block;
+ (void)setUploadCount:(NSUInteger)count;

/**
 *  设置Cache上传时机
 *
 *  @param when AKErrorUploadWhen
 */
+ (void)setUploadCacheWhen:(AKErrorUploadWhen)when;

+ (void)setCacheIdentifier:(NSString *)identifier;

+ (void)cache:(id<AKErrorProtocol>)error;
+ (void)upload:(id<AKErrorProtocol>)error;

@end

NS_ASSUME_NONNULL_END
