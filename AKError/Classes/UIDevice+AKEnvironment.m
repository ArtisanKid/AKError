//
//  UIDevice+AKEnvironment.m
//  Pods
//
//  Created by 李翔宇 on 16/9/8.
//
//

#import "UIDevice+AKEnvironment.h"
#import <sys/sysctl.h>

//资料来源 http://www.enterpriseios.com/wiki/iOS_Devices

NSString *const UIDeviceModel_iPhone_SE = @"iPhone SE";                                // iPhone8,4	2016-03-15  9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Pro_97_Cellular = @"iPad Pro 9.7-inch (Cellular)";  // iPad6,4	2016-03-15	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Pro_97_WiFi = @"iPad Pro 9.7-inch (WiFi)";          // iPad6,3	2016-03-15	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Pro_129_Cellular = @"iPad Pro 12.9-inch (Cellular)";// iPad6,8	2015-10-16	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Pro_129_WiFi = @"iPad Pro 12.9-inch (WiFi)";        // iPad6,7	2015-10-16	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_6s_Plus = @"iPhone 6s+";                          // iPhone8,2	2015-09-09	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_6s = @"iPhone 6s";                                // iPhone8,1	2015-09-09	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_4_Cellular = @"iPad Mini 4 (Cellular)";        // iPad5,2	2015-09-09	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_4_WiFi = @"iPad Mini 4 (WiFi)";                // iPad5,1	2015-09-09	9.3.5 (13G36)
NSString *const UIDeviceModel_iPod_touch_6 = @"iPod touch 6";                          // iPod7,1	2015-06-26	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Air_2_Cellular = @"iPad Air 2 (Cellular)";          // iPad5,4	2014-10-13	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Air_2_WiFi = @"iPad Air 2 (WiFi)";                  // iPad5,3	2014-10-13	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_3_China = @"iPad Mini 3 (China)";              // iPad4,9	2014-10-13	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_3_Cellular = @"iPad Mini 3 (Cellular)";        // iPad4,8	2014-10-13	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_3_WiFi = @"iPad Mini 3 (WiFi)";                // iPad4,7	2014-10-13	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_6 = @"iPhone 6";                                  // iPhone7,2	2014-09-09	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_6_Plus = @"iPhone 6+";                            // iPhone7,1	2014-09-09	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_2_China = @"iPad Mini 2 (China)";              // iPad4,6	2014-03-04	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Air_China = @"iPad Air (China)";                    // iPad4,3	2014-03-04	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_2_Cellular = @"iPad Mini 2 (Cellular)";        // iPad4,5	2013-10-16	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_2_WiFi = @"iPad Mini 2 (WiFi)";                // iPad4,4	2013-10-16	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Air_Cellular = @"iPad Air (Cellular)";              // iPad4,2	2013-10-16	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Air_WiFi = @"iPad Air (WiFi)";                      // iPad4,1	2013-10-16	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_5s_Global = @"iPhone 5s (Global)";                // iPhone6,2	2013-09-14	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_5s_GSM = @"iPhone 5s (GSM)";                      // iPhone6,1	2013-09-14	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_5c_Global = @"iPhone 5c (Global)";                // iPhone5,4	2013-09-14	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_5c_GSM = @"iPhone 5c (GSM)";                      // iPhone5,3	2013-09-14	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_4_Global = @"iPad 4 (Global)";                      // iPad3,6	2012-11-06	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_4_GSM = @"iPad 4 (GSM)";                            // iPad3,5	2012-11-06	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_Global = @"iPad Mini (Global)";                // iPad2,7	2012-11-06	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_GSM = @"iPad Mini (GSM)";                      // iPad2,6	2012-11-06	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_4_WiFi = @"iPad 4 (WiFi)";                          // iPad3,4	2012-10-29	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_Mini_WiFi = @"iPad Mini (WiFi)";                    // iPad2,5	2012-10-29	9.3.5 (13G36)
NSString *const UIDeviceModel_iPod_touch_5 = @"iPod touch 5";                          // iPod5,1	2012-09-14	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_5_Global = @"iPhone 5 (Global)";                  // iPhone5,2	2012-09-14	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_5_GSM = @"iPhone 5 (GSM)";                        // iPhone5,1	2012-09-14	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_3_GSM = @"iPad 3 (GSM)";                            // iPad3,3	2012-02-29	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_3_CDMA = @"iPad 3 (CDMA)";                          // iPad3,2	2012-02-29	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_3_WiFi = @"iPad 3 (WiFi)";                          // iPad3,1	2012-02-29	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_2_Mid_2012 = @"iPad 2 (Mid 2012)";                  // iPad2,4	2012-02-29	9.3.5 (13G36)
NSString *const UIDeviceModel_iPhone_4s = @"iPhone 4[S]";                              // iPhone4,1	2011-10-07	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_2_CDMA = @"iPad 2 (CDMA)";                          // iPad2,3	2011-03-03	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_2_GSM = @"iPad 2 (GSM)";                            // iPad2,2	2011-03-03	9.3.5 (13G36)
NSString *const UIDeviceModel_iPad_2_WiFi = @"iPad 2 (WiFi)";                          // iPad2,1	2011-03-03	9.3.5 (13G36)
NSString *const UIDeviceModel_Apple_TV_4_2015 = @"Apple TV 4 (2015)";                  // AppleTV5,3	2015-10-29	9.2.2 (13Y825)
NSString *const UIDeviceModel_Apple_TV_3_2013 = @"Apple TV 3 (2013)";                  // AppleTV3,2	2013-01-25	8.4.1 (12H523)
NSString *const UIDeviceModel_Apple_TV_3 = @"Apple TV 3";                              // AppleTV3,1	2012-02-29	8.4.1 (12H523)
NSString *const UIDeviceModel_Apple_Watch_42 = @"Apple Watch (42mm)";                  // Watch1,2	2015-02-25	1.0.1 (12S632)
NSString *const UIDeviceModel_Apple_Watch_38 = @"Apple Watch (38mm)";                  // Watch1,1	2015-02-25	1.0.1 (12S632)
NSString *const UIDeviceModel_Apple_TV_2G = @"Apple TV 2G";                            // AppleTV2,1	2010-09-27	7.1.2 (11D258)
NSString *const UIDeviceModel_iPhone_4_GSM_2012 = @"iPhone 4 (GSM / 2012)";            // iPhone3,2	2012-09-14	7.1.2 (11D257)
NSString *const UIDeviceModel_iPhone_4_CDMA = @"iPhone 4 (CDMA)";                      // iPhone3,3	2011-01-27	7.1.2 (11D257)
NSString *const UIDeviceModel_iPhone_4_GSM = @"iPhone 4 (GSM)";                        // iPhone3,1	2010-06-17	7.1.2 (11D257)
NSString *const UIDeviceModel_iPod_touch_4 = @"iPod touch 4";                          // iPod4,1	2010-08-31	6.1.6 (10B500)
NSString *const UIDeviceModel_iPhone_3Gs = @"iPhone 3G[S]";                            // iPhone2,1	2009-06-10	6.1.6 (10B500)
NSString *const UIDeviceModel_iPad_1 = @"iPad 1";                                      // iPad1,1	2010-03-29	5.1.1 (9B206)	
NSString *const UIDeviceModel_iPod_touch_3 = @"iPod touch 3";                          // iPod3,1	2009-09-04	5.1.1 (9B206)	
NSString *const UIDeviceModel_iPod_touch_2G = @"iPod touch 2G";                        // iPod2,1	2008-09-05	4.2.1 (8C148)	
NSString *const UIDeviceModel_iPhone_3G = @"iPhone 3G";                                // iPhone1,2	2008-07-08	4.2.1 (8C148)	
NSString *const UIDeviceModel_iPod_touch_1G = @"iPod touch 1G";                        // iPod1,1	2007-09-11	1.1.5 (4B1)	
NSString *const UIDeviceModel_iPhone_2G = @"iPhone 2G";                                // iPhone1,1	2007-06-28	3.1.3 (7E18)

NSString *const UIDeviceModelSimulatorI386 = @"iPhone Simulator (i386)";
NSString *const UIDeviceModelSimulatorX86_64 = @"iPhone Simulator (x86_64)";
NSString *const UIDeviceModelSimulator = @"iPhone Simulator";

@implementation UIDevice (AKEnvironment)

+ (NSString *)modelName {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

+ (AKEDeviceModel)ak_model {
    NSString *name = [UIDevice modelName];
    if([name isEqualToString:@"iPhone8,4"]) { return AKEDeviceModel_iPhone_SE; }
    else if([name isEqualToString:@"iPad6,4"]) { return AKEDeviceModel_iPad_Pro_97_Cellular; }
    else if([name isEqualToString:@"iPad6,3"]) { return AKEDeviceModel_iPad_Pro_97_WiFi; }
    else if([name isEqualToString:@"iPad6,8"]) { return AKEDeviceModel_iPad_Pro_129_Cellular; }
    else if([name isEqualToString:@"iPad6,7"]) { return AKEDeviceModel_iPad_Pro_129_WiFi; }
    else if([name isEqualToString:@"iPhone8,2"]) { return AKEDeviceModel_iPhone_6s_Plus; }
    else if([name isEqualToString:@"iPhone8,1"]) { return AKEDeviceModel_iPhone_6s; }
    else if([name isEqualToString:@"iPad5,2"]) { return AKEDeviceModel_iPad_Mini_4_Cellular; }
    else if([name isEqualToString:@"iPad5,1"]) { return AKEDeviceModel_iPad_Mini_4_WiFi; }
    else if([name isEqualToString:@"iPod7,1"]) { return AKEDeviceModel_iPod_touch_6; }
    else if([name isEqualToString:@"iPad5,4"]) { return AKEDeviceModel_iPad_Air_2_Cellular; }
    else if([name isEqualToString:@"iPad5,3"]) { return AKEDeviceModel_iPad_Air_2_WiFi; }
    else if([name isEqualToString:@"iPad4,9"]) { return AKEDeviceModel_iPad_Mini_3_China; }
    else if([name isEqualToString:@"iPad4,8"]) { return AKEDeviceModel_iPad_Mini_3_Cellular; }
    else if([name isEqualToString:@"iPad4,7"]) { return AKEDeviceModel_iPad_Mini_3_WiFi; }
    else if([name isEqualToString:@"iPhone7,2"]) { return AKEDeviceModel_iPhone_6; }
    else if([name isEqualToString:@"iPhone7,1"]) { return AKEDeviceModel_iPhone_6_Plus; }
    else if([name isEqualToString:@"iPad4,6"]) { return AKEDeviceModel_iPad_Mini_2_China; }
    else if([name isEqualToString:@"iPad4,3"]) { return AKEDeviceModel_iPad_Air_China; }
    else if([name isEqualToString:@"iPad4,5"]) { return AKEDeviceModel_iPad_Mini_2_Cellular; }
    else if([name isEqualToString:@"iPad4,4"]) { return AKEDeviceModel_iPad_Mini_2_WiFi; }
    else if([name isEqualToString:@"iPad4,2"]) { return AKEDeviceModel_iPad_Air_Cellular; }
    else if([name isEqualToString:@"iPad4,1"]) { return AKEDeviceModel_iPad_Air_WiFi; }
    else if([name isEqualToString:@"iPhone6,2"]) { return AKEDeviceModel_iPhone_5s_Global; }
    else if([name isEqualToString:@"iPhone6,1"]) { return AKEDeviceModel_iPhone_5s_GSM; }
    else if([name isEqualToString:@"iPhone5,4"]) { return AKEDeviceModel_iPhone_5c_Global; }
    else if([name isEqualToString:@"iPhone5,3"]) { return AKEDeviceModel_iPhone_5c_GSM; }
    else if([name isEqualToString:@"iPad3,6"]) { return AKEDeviceModel_iPad_4_Global; }
    else if([name isEqualToString:@"iPad3,5"]) { return AKEDeviceModel_iPad_4_GSM; }
    else if([name isEqualToString:@"iPad2,7"]) { return AKEDeviceModel_iPad_Mini_Global; }
    else if([name isEqualToString:@"iPad2,6"]) { return AKEDeviceModel_iPad_Mini_GSM; }
    else if([name isEqualToString:@"iPad3,4"]) { return AKEDeviceModel_iPad_4_WiFi; }
    else if([name isEqualToString:@"iPad2,5"]) { return AKEDeviceModel_iPad_Mini_WiFi; }
    else if([name isEqualToString:@"iPod5,1"]) { return AKEDeviceModel_iPod_touch_5; }
    else if([name isEqualToString:@"iPhone5,2"]) { return AKEDeviceModel_iPhone_5_Global; }
    else if([name isEqualToString:@"iPhone5,1"]) { return AKEDeviceModel_iPhone_5_GSM; }
    else if([name isEqualToString:@"iPad3,3"]) { return AKEDeviceModel_iPad_3_GSM; }
    else if([name isEqualToString:@"iPad3,2"]) { return AKEDeviceModel_iPad_3_CDMA; }
    else if([name isEqualToString:@"iPad3,1"]) { return AKEDeviceModel_iPad_3_WiFi; }
    else if([name isEqualToString:@"iPad2,4"]) { return AKEDeviceModel_iPad_2_Mid_2012; }
    else if([name isEqualToString:@"iPhone4,1"]) { return AKEDeviceModel_iPhone_4s; }
    else if([name isEqualToString:@"iPad2,3"]) { return AKEDeviceModel_iPad_2_CDMA; }
    else if([name isEqualToString:@"iPad2,2"]) { return AKEDeviceModel_iPad_2_GSM; }
    else if([name isEqualToString:@"iPad2,1"]) { return AKEDeviceModel_iPad_2_WiFi; }
    else if([name isEqualToString:@"AppleTV5,3"]) { return AKEDeviceModel_Apple_TV_4_2015; }
    else if([name isEqualToString:@"AppleTV3,2"]) { return AKEDeviceModel_Apple_TV_3_2013; }
    else if([name isEqualToString:@"AppleTV3,1"]) { return AKEDeviceModel_Apple_TV_3; }
    else if([name isEqualToString:@"Watch1,2"]) { return AKEDeviceModel_Apple_Watch_42; }
    else if([name isEqualToString:@"Watch1,1"]) { return AKEDeviceModel_Apple_Watch_38; }
    else if([name isEqualToString:@"AppleTV2,1"]) { return AKEDeviceModel_Apple_TV_2G; }
    else if([name isEqualToString:@"iPhone3,2"]) { return AKEDeviceModel_iPhone_4_GSM_2012; }
    else if([name isEqualToString:@"iPhone3,3"]) { return AKEDeviceModel_iPhone_4_CDMA; }
    else if([name isEqualToString:@"iPhone3,1"]) { return AKEDeviceModel_iPhone_4_GSM; }
    else if([name isEqualToString:@"iPod4,1"]) { return AKEDeviceModel_iPod_touch_4; }
    else if([name isEqualToString:@"iPhone2,1"]) { return AKEDeviceModel_iPhone_3Gs; }
    else if([name isEqualToString:@"iPad1,1"]) { return AKEDeviceModel_iPad_1; }
    else if([name isEqualToString:@"iPod3,1"]) { return AKEDeviceModel_iPod_touch_3; }
    else if([name isEqualToString:@"iPod2,1"]) { return AKEDeviceModel_iPod_touch_2G; }
    else if([name isEqualToString:@"iPhone1,2"]) { return AKEDeviceModel_iPhone_3G; }
    else if([name isEqualToString:@"iPod1,1"]) { return AKEDeviceModel_iPod_touch_1G; }
    else if([name isEqualToString:@"iPhone1,1"]) { return AKEDeviceModel_iPhone_2G; }
    
    else if ([name isEqualToString:@"i386"]) { return AKEDeviceModelSimulatorI386; }
    else if ([name isEqualToString:@"x86_64"]) {return AKEDeviceModelSimulatorX86_64; }
    return AKEDeviceModelNone;
}

+ (NSString *)ak_modelName {
    switch ([UIDevice ak_model]) {
        case AKEDeviceModel_iPhone_SE: return UIDeviceModel_iPhone_SE;
        case AKEDeviceModel_iPad_Pro_97_Cellular: return UIDeviceModel_iPad_Pro_97_Cellular;
        case AKEDeviceModel_iPad_Pro_97_WiFi: return UIDeviceModel_iPad_Pro_97_WiFi;
        case AKEDeviceModel_iPad_Pro_129_Cellular: return UIDeviceModel_iPad_Pro_129_Cellular;
        case AKEDeviceModel_iPad_Pro_129_WiFi: return UIDeviceModel_iPad_Pro_129_WiFi;
        case AKEDeviceModel_iPhone_6s_Plus: return UIDeviceModel_iPhone_6s_Plus;
        case AKEDeviceModel_iPhone_6s: return UIDeviceModel_iPhone_6s;
        case AKEDeviceModel_iPad_Mini_4_Cellular: return UIDeviceModel_iPad_Mini_4_Cellular;
        case AKEDeviceModel_iPad_Mini_4_WiFi: return UIDeviceModel_iPad_Mini_4_WiFi;
        case AKEDeviceModel_iPod_touch_6: return UIDeviceModel_iPod_touch_6;
        case AKEDeviceModel_iPad_Air_2_Cellular: return UIDeviceModel_iPad_Air_2_Cellular;
        case AKEDeviceModel_iPad_Air_2_WiFi: return UIDeviceModel_iPad_Air_2_WiFi;
        case AKEDeviceModel_iPad_Mini_3_China: return UIDeviceModel_iPad_Mini_3_China;
        case AKEDeviceModel_iPad_Mini_3_Cellular: return UIDeviceModel_iPad_Mini_3_Cellular;
        case AKEDeviceModel_iPad_Mini_3_WiFi: return UIDeviceModel_iPad_Mini_3_WiFi;
        case AKEDeviceModel_iPhone_6: return UIDeviceModel_iPhone_6;
        case AKEDeviceModel_iPhone_6_Plus: return UIDeviceModel_iPhone_6_Plus;
        case AKEDeviceModel_iPad_Mini_2_China: return UIDeviceModel_iPad_Mini_2_China;
        case AKEDeviceModel_iPad_Air_China: return UIDeviceModel_iPad_Air_China;
        case AKEDeviceModel_iPad_Mini_2_Cellular: return UIDeviceModel_iPad_Mini_2_Cellular;
        case AKEDeviceModel_iPad_Mini_2_WiFi: return UIDeviceModel_iPad_Mini_2_WiFi;
        case AKEDeviceModel_iPad_Air_Cellular: return UIDeviceModel_iPad_Air_Cellular;
        case AKEDeviceModel_iPad_Air_WiFi: return UIDeviceModel_iPad_Air_WiFi;
        case AKEDeviceModel_iPhone_5s_Global: return UIDeviceModel_iPhone_5s_Global;
        case AKEDeviceModel_iPhone_5s_GSM: return UIDeviceModel_iPhone_5s_GSM;
        case AKEDeviceModel_iPhone_5c_Global: return UIDeviceModel_iPhone_5c_Global;
        case AKEDeviceModel_iPhone_5c_GSM: return UIDeviceModel_iPhone_5c_GSM;
        case AKEDeviceModel_iPad_4_Global: return UIDeviceModel_iPad_4_Global;
        case AKEDeviceModel_iPad_4_GSM: return UIDeviceModel_iPad_4_GSM;
        case AKEDeviceModel_iPad_Mini_Global: return UIDeviceModel_iPad_Mini_Global;
        case AKEDeviceModel_iPad_Mini_GSM: return UIDeviceModel_iPad_Mini_GSM;
        case AKEDeviceModel_iPad_4_WiFi: return UIDeviceModel_iPad_4_WiFi;
        case AKEDeviceModel_iPad_Mini_WiFi: return UIDeviceModel_iPad_Mini_WiFi;
        case AKEDeviceModel_iPod_touch_5: return UIDeviceModel_iPod_touch_5;
        case AKEDeviceModel_iPhone_5_Global: return UIDeviceModel_iPhone_5_Global;
        case AKEDeviceModel_iPhone_5_GSM: return UIDeviceModel_iPhone_5_GSM;
        case AKEDeviceModel_iPad_3_GSM: return UIDeviceModel_iPad_3_GSM;
        case AKEDeviceModel_iPad_3_CDMA: return UIDeviceModel_iPad_3_CDMA;
        case AKEDeviceModel_iPad_3_WiFi: return UIDeviceModel_iPad_3_WiFi;
        case AKEDeviceModel_iPad_2_Mid_2012: return UIDeviceModel_iPad_2_Mid_2012;
        case AKEDeviceModel_iPhone_4s: return UIDeviceModel_iPhone_4s;
        case AKEDeviceModel_iPad_2_CDMA: return UIDeviceModel_iPad_2_CDMA;
        case AKEDeviceModel_iPad_2_GSM: return UIDeviceModel_iPad_2_GSM;
        case AKEDeviceModel_iPad_2_WiFi: return UIDeviceModel_iPad_2_WiFi;
        case AKEDeviceModel_Apple_TV_4_2015: return UIDeviceModel_Apple_TV_4_2015;
        case AKEDeviceModel_Apple_TV_3_2013: return UIDeviceModel_Apple_TV_3_2013;
        case AKEDeviceModel_Apple_TV_3: return UIDeviceModel_Apple_TV_3;
        case AKEDeviceModel_Apple_Watch_42: return UIDeviceModel_Apple_Watch_42;
        case AKEDeviceModel_Apple_Watch_38: return UIDeviceModel_Apple_Watch_38;
        case AKEDeviceModel_Apple_TV_2G: return UIDeviceModel_Apple_TV_2G;
        case AKEDeviceModel_iPhone_4_GSM_2012: return UIDeviceModel_iPhone_4_GSM_2012;
        case AKEDeviceModel_iPhone_4_CDMA: return UIDeviceModel_iPhone_4_CDMA;
        case AKEDeviceModel_iPhone_4_GSM: return UIDeviceModel_iPhone_4_GSM;
        case AKEDeviceModel_iPod_touch_4: return UIDeviceModel_iPod_touch_4;
        case AKEDeviceModel_iPhone_3Gs: return UIDeviceModel_iPhone_3Gs;
        case AKEDeviceModel_iPad_1: return UIDeviceModel_iPad_1;
        case AKEDeviceModel_iPod_touch_3: return UIDeviceModel_iPod_touch_3;
        case AKEDeviceModel_iPod_touch_2G: return UIDeviceModel_iPod_touch_2G;
        case AKEDeviceModel_iPhone_3G: return UIDeviceModel_iPhone_3G;
        case AKEDeviceModel_iPod_touch_1G: return UIDeviceModel_iPod_touch_1G;
        case AKEDeviceModel_iPhone_2G: return UIDeviceModel_iPhone_2G;
            
        case AKEDeviceModelSimulatorI386: return UIDeviceModelSimulatorI386;
        case AKEDeviceModelSimulatorX86_64: return UIDeviceModelSimulatorX86_64;
    }
    return @"未知设备";
}

@end
