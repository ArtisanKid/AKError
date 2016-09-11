//
//  LXYEnvironmentProtocol.h
//  Pods
//
//  Created by 李翔宇 on 15/11/26.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AKERadioAccessState) {
    AKERadioAccessStateNone = 0,
    AKERadioAccessState2G,
    AKERadioAccessState2_5G,
    AKERadioAccessState3G,
    AKERadioAccessState3_5G,
    AKERadioAccessState4G
};

NS_ASSUME_NONNULL_BEGIN

@protocol AKEnvironmentProtocol <NSObject>

/**
 *  内网IP
 */
@property (nonatomic, copy, readonly) NSString *intraIP;

/**
 *  公网IP获取有延迟
 */
@property (nonatomic, copy, readonly) NSString *publicIP;

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
@property (nonatomic, assign, readonly) NSInteger networkType;

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
 *  运营商信息
 */
@property (nonatomic, strong, readonly) id carrier;

/**
 *  设备信息
 */
@property (nonatomic, strong, readonly) id device;

/**
 *  进程信息
 */
@property (nonatomic, strong, readonly) id process;

@optional

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
