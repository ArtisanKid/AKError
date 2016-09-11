//
//  AKEUserProtocol.h
//  Pods
//
//  Created by 李翔宇 on 16/8/18.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AKEUserProtocol <NSObject>

@optional

/**
 *  用户描述
 *
 *  @return NSDictionary
 */
- (NSDictionary *)dictionary;

/**
 *  用户描述
 *
 *  @return JSON
 */
- (NSString *)json;

@end

NS_ASSUME_NONNULL_END
