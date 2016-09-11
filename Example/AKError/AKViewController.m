//
//  AKViewController.m
//  AKError
//
//  Created by Freud on 09/06/2016.
//  Copyright (c) 2016 Freud. All rights reserved.
//

#import "AKViewController.h"
#import "AKTest.h"
#import <AKError/AKError.h>
#import <AKError/AKErrorManager.h>
#import "AKErrorMacro.h"
#import <AKError/AKEnvironment.h>

@interface AKViewController ()

@end

@implementation AKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    AKErrorLogState = YES;
    
    [AKError setEnvironment:[AKEnvironment environment]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i = 0; i < 18; i++) {
            [[AKError errorWithExtra:@{@"time" : @(NSDate.date.timeIntervalSince1970)} alert:[NSString stringWithFormat:@"第%@条错误", @(i)] detail:nil] cache];
        }
    });
    
    [AKErrorManager setUploadCacheWhen:AKErrorUploadWhenEnterBackground];
    [AKErrorManager setUploadBlock:^BOOL(NSArray<NSDictionary *> *errors) {
        NSLog(@"errors.count %@", @(errors.count));
        return YES;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
