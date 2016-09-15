//
//  LXYEnvironment.m
//  Pods
//
//  Created by 李翔宇 on 15/11/26.
//
//

#import "AKEnvironment.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <mach/mach_host.h>
#import <mach/task.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AKErrorMacro.h"
#import "UIDevice+AKEnvironment.h"

@interface AKEnvironment ()

@property (nonatomic, strong) CTTelephonyNetworkInfo *telephonyNetwork;
@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, strong) CTCarrier *innerCarrier;
@property (nonatomic, strong) UIDevice *innerDevice;
@property (nonatomic, strong) NSProcessInfo *innerProcess;

@end

@implementation AKEnvironment

+ (AKEnvironment *)environment {
    static AKEnvironment *environment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        environment = [[super allocWithZone:NULL] init];
        environment.telephonyNetwork = [[CTTelephonyNetworkInfo alloc] init];
        
        environment.innerCarrier = environment.telephonyNetwork.subscriberCellularProvider;
        environment.innerDevice = [UIDevice currentDevice];
        environment.innerProcess = [NSProcessInfo processInfo];
        
        environment.reachability = [Reachability reachabilityWithHostName:@"http://www.apple.com"];
        [environment.reachability startNotifier];
    });
    return environment;
}

+ (id)alloc {
    return [self environment];
}

+ (id)allocWithZone:(NSZone * _Nullable)zone {
    return [self environment];
}

- (id)copy {
    return self;
}

- (id)copyWithZone:(NSZone * _Nullable)zone {\
    return self;
}

#pragma mark- 协议方法

//内网IP获取 http://stackoverflow.com/questions/7072989/iphone-ipad-osx-how-to-get-my-ip-address-programmatically

- (NSString *)intraIP {
    
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
    
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    BOOL preferIPv4 = YES;
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     }];
    return address ? address : @"0.0.0.0";
}

@synthesize publicIP = _publicIP;
- (NSString *)publicIP {
    NSURL *url = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo2.php?ip=myip"];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            AKErrorLog(@"获取Public IP错误 error:%@", error);
            return;
        }
        
        if(!data.length) {
            AKErrorLog(@"获取Public IP失败");
            return;
        }
        
        NSError *parseError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
        if (parseError) {
            AKErrorLog(@"解析Public IP错误 error:%@", parseError);
            return;
        }
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            AKErrorLog(@"Public IP数据类型错误");
            return;
        }
        
        NSDictionary *ipDic = dic[@"data"];
        if (![ipDic isKindOfClass:[NSDictionary class]]) {
            AKErrorLog(@"Public IP数据类型错误");
            return;
        }
        
        NSString *ip = ipDic[@"ip"];
        if (![ipDic isKindOfClass:[NSString class]]) {
            AKErrorLog(@"Public IP数据类型错误");
            return;
        }
        
        AKErrorLog(@"Public IP：%@", ip);
        
        _publicIP = ip;
    }] resume];
    
    if(!_publicIP.length) {
        _publicIP = @"0.0.0.0";
    }
    return _publicIP;
}

- (AKERadioAccessState)radioAccessState {
    //对应说明 http://stackoverflow.com/questions/25405566/mapping-ios-7-constants-to-2g-3g-4g-lte-etc
    
    AKERadioAccessState _radioAccessState = AKERadioAccessStateNone;
    NSString *technology = self.telephonyNetwork.currentRadioAccessTechnology;
    if([technology isEqualToString:CTRadioAccessTechnologyGPRS] ||
       [technology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        _radioAccessState = AKERadioAccessState2G;
    } else if([technology isEqualToString:CTRadioAccessTechnologyEdge]) {
        _radioAccessState = AKERadioAccessState2_5G;
    } else if([technology isEqualToString:CTRadioAccessTechnologyWCDMA] ||
              [technology isEqualToString:CTRadioAccessTechnologyHSUPA] ||
              [technology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
              [technology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
              [technology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
        _radioAccessState = AKERadioAccessState3G;
    } else if([technology isEqualToString:CTRadioAccessTechnologyHSDPA] ||
              [technology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        _radioAccessState = AKERadioAccessState3_5G;
    } else  if([technology isEqualToString:CTRadioAccessTechnologyLTE]) {
        _radioAccessState = AKERadioAccessState4G;
    } else {
        _radioAccessState = AKERadioAccessStateNone;
    }
    return _radioAccessState;
}

- (NSString *)radioAccessName {
    NSString *_radioAccessName = nil;
    switch (self.radioAccessState) {
        case AKERadioAccessStateNone: { _radioAccessName = nil; break; }
        case AKERadioAccessState2G: { _radioAccessName = @"2G"; break; }
        case AKERadioAccessState2_5G: { _radioAccessName = @"2.5G"; break; }
        case AKERadioAccessState3G: { _radioAccessName = @"3G"; break; }
        case AKERadioAccessState3_5G: { _radioAccessName = @"3.5G"; break; }
        case AKERadioAccessState4G: { _radioAccessName = @"4G"; break; }
    }
    return _radioAccessName;
}

- (NetworkStatus)networkType {
    return self.reachability.currentReachabilityStatus;
}

- (NSString *)networkName {
    switch (self.networkType) {
        case NotReachable: { return @"未连接网络"; }
        case ReachableViaWWAN: { return self.radioAccessName; }
        case ReachableViaWiFi: { return @"已连接WiFi"; }
    }
    return @"网络状态未知";
}

- (NSUInteger)freeDisk {
    CGFloat totalFreeSpace = 0.f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:paths.lastObject error:&error];
    if (attributes) {
        totalFreeSpace = [attributes[NSFileSystemFreeSize] unsignedIntegerValue];
    }
    if(error) {
        AKErrorLog(@"获取磁盘信息错误 error：%@", error);
    }
    return totalFreeSpace;
}

//ROM使用情况 http://stackoverflow.com/questions/5712527/how-to-detect-total-available-free-disk-space-on-the-iphone-ipad-device

- (NSUInteger)usedDisk {
    static CGFloat totalSpace = 0.f;
    
    if(totalSpace > 0.f) {
        return totalSpace - self.freeDisk;
    }
    
    //因为要获取整个磁盘的大小，所以需要用通过文件系统的属性来获取
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:paths.lastObject error:&error];
    if (attributes) {
        totalSpace = [attributes[NSFileSystemSize] unsignedIntegerValue];
    }
    if(error) {
        AKErrorLog(@"获取磁盘信息错误 error：%@", error);
    }
    return totalSpace - self.freeDisk;
}

//RAM的使用情况 http://stackoverflow.com/questions/5012886/determining-the-available-amount-of-ram-on-an-ios-device

- (NSUInteger)freeMemory {
    vm_statistics_data_t vm_stat;
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(natural_t);
    vm_size_t pagesize;
    
    mach_port_t host_port = mach_host_self();
    host_page_size(host_port, &pagesize);
    kern_return_t return_t = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (return_t != KERN_SUCCESS) {
        AKErrorLog(@"Failed to fetch vm statistics 返回值：%@", @(return_t));
    }
    
    /* Stats in bytes */ 
    natural_t mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

- (NSUInteger)usedMemory {
    vm_statistics_data_t vm_stat;
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(natural_t);
    vm_size_t pagesize;
    
    mach_port_t host_port = mach_host_self();
    host_page_size(host_port, &pagesize);
    kern_return_t return_t = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (return_t != KERN_SUCCESS) {
        AKErrorLog(@"Failed to fetch vm statistics 返回值：%@", @(return_t));
    }
    
    /* Stats in bytes */ 
    natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    return mem_used;
}

- (NSUInteger)appUsedDisk {
    //因为要获取应用的大小，所以需要用通过文件的属性来获取
    
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:NSHomeDirectory() error:&error];
    if (attributes) {
        return attributes.fileSize;
    }
    if(error) {
        AKErrorLog(@"获取磁盘信息错误 error：%@", error);
    }
    return 0;
}

- (NSUInteger)appUsedMemory {
    task_basic_info_data_t task_basic_info;
    mach_msg_type_number_t host_size = TASK_BASIC_INFO_COUNT;
    
    kern_return_t return_t = task_info(current_task(), TASK_BASIC_INFO, (task_info_t)&task_basic_info, &host_size);
    if (return_t != KERN_SUCCESS) {
        AKErrorLog(@"Failed to fetch task info 返回值：%@", @(return_t));
    }
    return task_basic_info.resident_size;
}

@synthesize carrier = _carrier;
- (NSMutableDictionary *)carrier {
    if(!_carrier) {
        _carrier = [NSMutableDictionary dictionary];
    }
    
    _carrier[@"currentRadioAccessTechnology"] = self.telephonyNetwork.currentRadioAccessTechnology;
    _carrier[@"carrierName"] = self.innerCarrier.carrierName;
    _carrier[@"MCC"] = self.innerCarrier.mobileCountryCode;
    _carrier[@"MNC"] = self.innerCarrier.mobileNetworkCode;
    _carrier[@"isoCountryCode"] = self.innerCarrier.isoCountryCode;
    
    return _carrier;
}

@synthesize device = _device;
- (NSMutableDictionary *)device {
    if(!_device) {
        _device = [NSMutableDictionary dictionary];
    }
    
    _device[@"name"] = self.innerDevice.name;
    _device[@"model"] = self.innerDevice.model;
    _device[@"systemName"] = self.innerDevice.systemName;
    _device[@"systemVersion"] = self.innerDevice.systemVersion;
    
    switch (self.innerDevice.orientation) {
        case UIDeviceOrientationUnknown: { _device[@"orientation"] = @"未知"; break; }
        case UIDeviceOrientationPortrait: { _device[@"orientation"] = @"正竖"; break; }
        case UIDeviceOrientationPortraitUpsideDown: { _device[@"orientation"] = @"倒竖"; break; }
        case UIDeviceOrientationLandscapeLeft: { _device[@"orientation"] = @"左水平"; break; }
        case UIDeviceOrientationLandscapeRight: { _device[@"orientation"] = @"右水平"; break; }
        case UIDeviceOrientationFaceUp: { _device[@"orientation"] = @"面向上"; break; }
        case UIDeviceOrientationFaceDown: { _device[@"orientation"] = @"面向下"; break;}
    }

    switch (self.innerDevice.batteryState) {
        case UIDeviceBatteryStateUnknown: { _device[@"battery"] = @"未知"; break; }
        case UIDeviceBatteryStateUnplugged: { 
            _device[@"battery"] = [@[@"未充电", @(self.innerDevice.batteryLevel)] componentsJoinedByString:@" "]; 
            break; 
        }
        case UIDeviceBatteryStateCharging: {
            _device[@"battery"] = [@[@"正在充电", @(self.innerDevice.batteryLevel)] componentsJoinedByString:@" "]; 
            break;
        }
        case UIDeviceBatteryStateFull: { _device[@"battery"] = @"充满电"; break; }
    }
    
    return _device;
}

@synthesize process = _process;
- (NSMutableDictionary *)process {
    if(!_process) {
        _process = [NSMutableDictionary dictionary];
    }
    
    _process[@"hostName"] = self.innerProcess.hostName;//进程执行的宿主计算机名
    _process[@"processName"] = self.innerProcess.processName;//进程名
    _process[@"operatingSystem"] = self.innerProcess.operatingSystemVersionString;
    
    _process[@"processorCount"] = @(self.innerProcess.processorCount);//CPU核数
    _process[@"activeProcessorCount"] = @(self.innerProcess.activeProcessorCount);//激活的CPU核数
    _process[@"physicalMemory"] = @(self.innerProcess.physicalMemory);//物理内存
    
    _process[@"systemUptime"] = @(self.innerProcess.systemUptime);//上次重启后的运行时长

    return _process;
}

- (NSString *)description {
    return [[self dictionary] description];
}

- (NSDictionary *)dictionary {
    NSDictionary *env = @{@"intraIP" : self.intraIP ? self.intraIP : @"",
                          @"publicIP" : self.publicIP ? self.publicIP : @"",
                          @"radioAccessName" : self.radioAccessName ? self.radioAccessName : @"",
                          @"networkName" : self.networkName ? self.networkName : @"",
                          @"freeDisk" : @(self.freeDisk),
                          @"usedDisk" : @(self.usedDisk),
                          @"freeMemory" : @(self.freeMemory),
                          @"usedMemory" : @(self.usedMemory),
                          @"appUsedDisk" : @(self.appUsedDisk),
                          @"appUsedMemory" : @(self.appUsedMemory),
                          @"customModel" : [UIDevice ak_modelName],
                          @"carrier" : self.carrier ? [self.carrier copy] : @{},
                          @"device" : self.device ? [self.device copy] : @{},
                          @"process" : self.process ? [self.process copy] : @{}};
    return env;
}

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

@end
