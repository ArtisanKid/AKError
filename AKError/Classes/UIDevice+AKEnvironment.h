//
//  UIDevice+AKEEnvironment.h
//  Pods
//
//  Created by 李翔宇 on 16/9/8.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AKEDeviceModel) {
    AKEDeviceModelNone,
    
    AKEDeviceModel_iPhone_SE,
    AKEDeviceModel_iPad_Pro_97_Cellular,
    AKEDeviceModel_iPad_Pro_97_WiFi,
    AKEDeviceModel_iPad_Pro_129_Cellular,
    AKEDeviceModel_iPad_Pro_129_WiFi,
    AKEDeviceModel_iPhone_6s_Plus,
    AKEDeviceModel_iPhone_6s,
    AKEDeviceModel_iPad_Mini_4_Cellular,
    AKEDeviceModel_iPad_Mini_4_WiFi,
    AKEDeviceModel_iPod_touch_6,
    AKEDeviceModel_iPad_Air_2_Cellular,
    AKEDeviceModel_iPad_Air_2_WiFi,
    AKEDeviceModel_iPad_Mini_3_China,
    AKEDeviceModel_iPad_Mini_3_Cellular,
    AKEDeviceModel_iPad_Mini_3_WiFi,
    AKEDeviceModel_iPhone_6,
    AKEDeviceModel_iPhone_6_Plus,
    AKEDeviceModel_iPad_Mini_2_China,
    AKEDeviceModel_iPad_Air_China,
    AKEDeviceModel_iPad_Mini_2_Cellular,
    AKEDeviceModel_iPad_Mini_2_WiFi,
    AKEDeviceModel_iPad_Air_Cellular,
    AKEDeviceModel_iPad_Air_WiFi,
    AKEDeviceModel_iPhone_5s_Global,
    AKEDeviceModel_iPhone_5s_GSM,
    AKEDeviceModel_iPhone_5c_Global,
    AKEDeviceModel_iPhone_5c_GSM,
    AKEDeviceModel_iPad_4_Global,
    AKEDeviceModel_iPad_4_GSM,
    AKEDeviceModel_iPad_Mini_Global,
    AKEDeviceModel_iPad_Mini_GSM,
    AKEDeviceModel_iPad_4_WiFi,
    AKEDeviceModel_iPad_Mini_WiFi,
    AKEDeviceModel_iPod_touch_5,
    AKEDeviceModel_iPhone_5_Global,
    AKEDeviceModel_iPhone_5_GSM,
    AKEDeviceModel_iPad_3_GSM,
    AKEDeviceModel_iPad_3_CDMA,
    AKEDeviceModel_iPad_3_WiFi,
    AKEDeviceModel_iPad_2_Mid_2012,
    AKEDeviceModel_iPhone_4s,
    AKEDeviceModel_iPad_2_CDMA,
    AKEDeviceModel_iPad_2_GSM,
    AKEDeviceModel_iPad_2_WiFi,
    AKEDeviceModel_Apple_TV_4_2015,
    AKEDeviceModel_Apple_TV_3_2013,
    AKEDeviceModel_Apple_TV_3,
    AKEDeviceModel_Apple_Watch_42,
    AKEDeviceModel_Apple_Watch_38,
    AKEDeviceModel_Apple_TV_2G,
    AKEDeviceModel_iPhone_4_GSM_2012,
    AKEDeviceModel_iPhone_4_CDMA,
    AKEDeviceModel_iPhone_4_GSM,
    AKEDeviceModel_iPod_touch_4,
    AKEDeviceModel_iPhone_3Gs,
    AKEDeviceModel_iPad_1,
    AKEDeviceModel_iPod_touch_3,
    AKEDeviceModel_iPod_touch_2G,
    AKEDeviceModel_iPhone_3G,
    AKEDeviceModel_iPod_touch_1G,
    AKEDeviceModel_iPhone_2G,
    
    AKEDeviceModelSimulatorI386,
    AKEDeviceModelSimulatorX86_64
};

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (AKEEnvironment)

/**
 *  设备类型
 */
+ (AKEDeviceModel)ak_model;

/**
 *  设备类型
 */
+ (NSString *)ak_modelName;

@end

NS_ASSUME_NONNULL_END
