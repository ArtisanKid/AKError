//
//  AKEnvironment.h
//  Pods
//
//  Created by 李翔宇 on 15/11/26.
//
//

#import <Foundation/Foundation.h>
#import "AKEnvironmentProtocol.h"
#import <CoreTelephony/CTCarrier.h>
#import "AKNetworkReachabilityManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AKEnvironment : NSObject<AKEnvironmentProtocol>

+ (AKEnvironment *)environment;

/**
 *  内网IP
 */
@property (nonatomic, copy, readonly) NSString *intraIP;

/**
 *  公网IP获取有延迟
 */
@property (nonatomic, copy, nullable, readonly) NSString *publicIP;

/**
 *  运营商状态
 */
@property (nonatomic, assign, readonly) AKERadioAccessState radioAccessState;

/**
 *  运营商状态
 */
@property (nonatomic, copy, readonly) NSString *radioAccessName;

/**
 *  网络类型
 */
@property (nonatomic, assign, readonly) AKNetworkReachabilityStatus networkType;

/**
 *  此字段的值，取决于networkType和carrierType + carrierStatus
 */
@property (nonatomic, strong, readonly) NSString *networkName;

//磁盘信息
@property (nonatomic, assign, readonly) NSUInteger freeDisk;
@property (nonatomic, assign, readonly) NSUInteger usedDisk;

//内存信息
@property (nonatomic, assign, readonly) NSUInteger freeMemory;
@property (nonatomic, assign, readonly) NSUInteger usedMemory;


/**
 *  当前应用占用磁盘
 */
@property (nonatomic, assign, readonly) NSUInteger appUsedDisk;
/**
 *  当前应用占用内存
 */
@property (nonatomic, assign, readonly) NSUInteger appUsedMemory;

/**
 *  运营商信息，默认填充
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *carrier;

/**
 *  设备信息，默认填充
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *device;

/**
 *  进程信息，默认填充
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *process;

/**
 *  环境描述
 *
 *  @return NSDictionary
 */
- (NSDictionary *)dictionary;

/**
 *  环境描述
 *
 *  @return JSON
 */
- (NSString *)json;

@end

NS_ASSUME_NONNULL_END
