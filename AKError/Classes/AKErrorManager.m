//
//  AKErrorManager.m
//  Pods
//
//  Created by 李翔宇 on 16/9/7.
//
//

#import "AKErrorManager.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
#import <YYModel/NSObject+YYModel.h>
#import "AKErrorMacro.h"

@interface AKErrorManager ()

@property(nonatomic, strong) AKErrorUploadBlock uploadBlock;
@property(nonatomic, assign) NSUInteger uploadCount;
@property(nonatomic, assign) AKErrorUploadWhen uploadWhen;
@property(nonatomic, strong) FMDatabaseQueue *dbQueue;
@property(nonatomic, strong) NSString *tableName;

@end

@implementation AKErrorManager

+ (AKErrorManager *)manager {
    static AKErrorManager *errorManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        errorManager = [[super allocWithZone:NULL] init];
        NSString *dbPath = [errorManager databasePath];
        errorManager.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        errorManager.uploadCount = 10;
        if(errorManager.dbQueue) {
            [errorManager makeTableWithIdentifier:nil];
        }
    });
    return errorManager;
}

+ (id)alloc {
    return [self manager];
}

+ (id)allocWithZone:(NSZone * _Nullable)zone {
    return [self manager];
}

- (id)copy {
    return self;
}

- (id)copyWithZone:(NSZone * _Nullable)zone {\
    return self;
}

#pragma mark- 私有方法
- (NSString *)databasePath {
    //拼装文件路径
    NSMutableArray *componentsM = [NSMutableArray array];
    [componentsM addObject:NSHomeDirectory()];
    [componentsM addObject:@"Library"];
    [componentsM addObject:@"AKError"];
    NSString *dbPath = [NSString pathWithComponents:componentsM];
    AKErrorLog(@"当前数据库操作路径:%@", dbPath);
    return dbPath;
}

- (void)makeTableWithIdentifier:(NSString *)identifier {
    self.tableName = @"AKError_Default";
    if(identifier.length) {
        self.tableName = [NSString stringWithFormat:@"AKError_%@", identifier];
    }
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( \
                     id             INTEGER PRIMARY KEY AUTOINCREMENT DEFAULT NULL, \
                     Class          TEXT DEFAULT NULL,\
                     ErrorID        TEXT DEFAULT NULL UNIQUE, \
                     Module         TEXT DEFAULT NULL, \
                     Extra          TEXT DEFAULT NULL, \
                     Alert          TEXT DEFAULT NULL, \
                     User           TEXT DEFAULT NULL, \
                     Error          TEXT DEFAULT NULL, \
                     Exception      TEXT DEFAULT NULL, \
                     Domain         TEXT DEFAULT NULL, \
                     Code           TEXT DEFAULT NULL, \
                     SubCode        TEXT DEFAULT NULL, \
                     Detail         TEXT DEFAULT NULL, \
                     Timestamp      TEXT DEFAULT NULL, \
                     Environment    TEXT DEFAULT NULL \
                     )", self.tableName];
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL canCommit = [db executeUpdate:sql];
        if (!canCommit) {
            AKErrorLog(@"数据库Create错误 Error:%@", db.lastError);
            *rollback = YES;
        }
    }];
}

- (UIBackgroundTaskIdentifier)startBackgroundTask:(NSString *)name {
    __block UIBackgroundTaskIdentifier identifier = UIBackgroundTaskInvalid;
    identifier = [[UIApplication sharedApplication] beginBackgroundTaskWithName:name expirationHandler:^{
        [self endBackgroudTask:identifier];
    }];
}

- (void)endBackgroudTask:(UIBackgroundTaskIdentifier)identifier {
    if (identifier == UIBackgroundTaskInvalid) {
        return;
    }
    [[UIApplication sharedApplication] endBackgroundTask:identifier];
}

+ (NSString *)whenOnEnum:(AKErrorUploadWhen)when {
    NSString *notification = nil;
    switch (when) {
        case AKErrorUploadWhenNever: {
            notification = nil;
            break;
        }
        case AKErrorUploadWhenFinishLaunching: {
            notification = UIApplicationDidFinishLaunchingNotification;
            break;
        }
        case AKErrorUploadWhenBecomeActive: {
            notification = UIApplicationDidBecomeActiveNotification;
            break;
        }
        case AKErrorUploadWhenEnterBackground: {
            notification = UIApplicationDidEnterBackgroundNotification;
            break;
        }
        default: break;
    }
    return notification;
}

- (void)applicationStateNotification:(NSNotification *)notification {
    NSTimeInterval timestamp = [NSDate date].timeIntervalSince1970;
    UIBackgroundTaskIdentifier identifier = [self startBackgroundTask:[@(timestamp) description]];
    if(identifier != UIBackgroundTaskInvalid) {
        if(self.uploadBlock) {
            NSArray<id<AKErrorProtocol>> *errors = [AKErrorManager errorsWithCount:self.uploadCount];
            while(errors.count) {
                if(!self.uploadBlock(errors)) {
                    break;
                }
                
                if(![AKErrorManager errorsRemoveCount:self.uploadCount]) {
                    break;
                }
                
                errors = [AKErrorManager errorsWithCount:self.uploadCount];
            }
        } 
    }
    [self endBackgroudTask:identifier];
}

+ (BOOL)errorsRemoveCount:(NSUInteger)count {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ LIMIT %@", [self manager].tableName, @(count)];
    __block BOOL canCommit = NO;
    [[self manager].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        canCommit = [db executeUpdate:sql];
        if (!canCommit) {
            AKErrorLog(@"数据库Create错误 Error:%@", db.lastError);
            *rollback = YES;
        }
    }];
    return canCommit;
}

AKJSONToObject

/**
 *  获取x条错误数据
 *
 *  @return 错误数组
 */
+ (NSArray<id<AKErrorProtocol>> *)errorsWithCount:(NSUInteger)count {
    NSString *sql = [NSString stringWithFormat:@"SELECT \
                     Class, ErrorID, Module, Extra, Alert, User, Error, Exception, Domain, Code, SubCode, Detail, Timestamp, Environment \
                     FROM %@ LIMIT %@", [self manager].tableName, @(count)];
    NSMutableArray<NSDictionary *> *errors = NSMutableArray.array;
    [[self manager].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            NSString *module = [set stringForColumn:@"Module"];
            NSString *alert = [set stringForColumn:@"Alert"];
            NSString *errorID = [set stringForColumn:@"errorID"];
            NSString *domain = [set stringForColumn:@"domain"];
            NSString *code = [set stringForColumn:@"code"];
            NSString *subCode = [set stringForColumn:@"subCode"];
            NSString *detail = [set stringForColumn:@"detail"];
            NSString *timestamp = [set stringForColumn:@"timestamp"];
            
            NSString *className = [set stringForColumn:@"Class"];
            Class errorClass = NSClassFromString(className);
            
            if(!errorClass) {
                continue;
            } 
                        
            NSString *extraJSON = [set stringForColumn:@"Extra"];
            id extra = [self jsonToObject:extraJSON];
            
            NSString *userJSON = [set stringForColumn:@"User"];
            id user = [self jsonToObject:userJSON];
            
            NSString *errorJSON = [set stringForColumn:@"Error"];
            id _error = [self jsonToObject:errorJSON];
            
            NSString *exceptionJSON = [set stringForColumn:@"Exception"];
            id exception = [self jsonToObject:exceptionJSON];
            
            NSString *environmentJSON = [set stringForColumn:@"Environment"];
            id environment = [self jsonToObject:environmentJSON];
            
            NSDictionary *error = @{@"module" : module ? module : @"",
                                    @"extra" : extra ? extra : [NSNull null],
                                    @"alert" : alert ? alert : @"",
                                    @"user" : user ? user : [NSNull null],
                                    @"error" : error ? error : [NSNull null],
                                    @"exception" : exception ? exception : [NSNull null],
                                    @"errorID" : errorID ? errorID : @"",
                                    @"domain" : domain ? domain : @"",
                                    @"code" : code ? code : @"",
                                    @"subCode" : subCode ? subCode : @"",
                                    @"detail" : detail ? detail : @"",
                                    @"timestamp" : timestamp ? timestamp : @"",
                                    @"environment" : environment ? environment : [NSNull null]};
            [errors addObject:error];
        }
        [set close];
    }];
    return errors;
}

#pragma mark- Custom
+ (void)setUploadBlock:(AKErrorUploadBlock)block {
    [self manager].uploadBlock = block;
}

+ (void)setUploadCount:(NSUInteger)count {
    [self manager].uploadCount = count;
}

+ (void)setUploadCacheWhen:(AKErrorUploadWhen)when {
    AKErrorManager *manager = [self manager];
    if(manager.uploadWhen == when) {
        return;
    }
    
    NSString *notification = [self whenOnEnum:manager.uploadWhen];
    
    if(notification.length) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notification object:nil];
    }
    
    manager.uploadWhen = when;
    notification = [self whenOnEnum:manager.uploadWhen];
    
    if(!notification.length) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(applicationStateNotification:) name:notification object:nil];
}

+ (void)setCacheIdentifier:(NSString *)identifier {
    [[self manager] makeTableWithIdentifier:identifier];
}

+ (void)cache:(id<AKErrorProtocol>)error {
    NSString *extraJSON = [error.extra yy_modelToJSONString];
    NSString *userJSON = [error.user yy_modelToJSONString];
    NSString *errorJSON = [error.error yy_modelToJSONString];
    NSString *exceptionJSON = [error.exception yy_modelToJSONString];
    NSString *environmentJSON = [error.environment yy_modelToJSONString];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ \
                     (Class, ErrorID, Module, Extra, Alert, User, Error, Exception, Domain, Code, SubCode, Detail, Timestamp, Environment) VALUES \
                     ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                     [self manager].tableName,
                     NSStringFromClass([error class]),
                     error.errorID,
                     @(error.module),
                     extraJSON,
                     error.alert,
                     userJSON,
                     errorJSON,
                     exceptionJSON,
                     @(error.domain),
                     @(error.code),
                     @(error.subCode),
                     error.detail,
                     @(error.timestamp),
                     environmentJSON];
     [[self manager].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL canCommit = [db executeUpdate:sql];
        if (!canCommit) {
            AKErrorLog(@"数据库存储错误 Error:%@", db.lastError);
            *rollback = YES;
        }
    }];
}

+ (void)upload:(id<AKErrorProtocol>)error {
    AKErrorUploadBlock uploadBlock = [self manager].uploadBlock;
    if(uploadBlock) {
        uploadBlock(@[error]);
    } else {
        [self cache:error];
    }
}

@end
