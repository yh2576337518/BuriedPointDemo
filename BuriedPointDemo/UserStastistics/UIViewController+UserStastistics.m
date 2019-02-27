//
//  UIViewController+UserStastistics.m
//  BuriedPointDemo
//
//  Created by 惠上科技 on 2019/2/26.
//  Copyright © 2019 惠上科技. All rights reserved.
//

#import "UIViewController+UserStastistics.h"
#import <objc/runtime.h>
#import "CommonUtility.h"
#import "StastisticsUtility.h"

@implementation UIViewController (UserStastistics)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swiz_ciewWillAppear:);
        [CommonUtility swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
        
        SEL originalSelector2 = @selector(viewWillDisappear:);
        SEL swizzledSelector2 = @selector(swiz_viewWillDisappear:);
        [CommonUtility swizzlingInClass:[self class] originalSelector:originalSelector2 swizzledSelector:swizzledSelector2];
    });
}

#pragma mark -------Method Swizzling
-(void)swiz_ciewWillAppear:(BOOL)animated{
    //插入需要执行的代码
    [self inject_viewWillAppear];
    [self swiz_ciewWillAppear:animated];
}

-(void)swiz_viewWillDisappear:(BOOL)animated{
    [self inject_viewWillDisappear];
    [self swiz_viewWillDisappear:animated];
}

//利用hook 统计所有页面的停留时长
-(void)inject_viewWillAppear{
    NSString *pageID = [self pageEventID:YES];
    if (pageID) {
        [StastisticsUtility sendEventToServer:pageID];
    }
}

-(void)inject_viewWillDisappear{
    NSString *pageID = [self pageEventID:NO];
    if (pageID) {
        [StastisticsUtility sendEventToServer:pageID];
    }
}

-(NSString *)pageEventID:(BOOL)bEnterPage{
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([self class]);
    return configDict[selfClassName][@"PageEventIDs"][bEnterPage?@"Enter":@"Leave"];
}

-(NSDictionary *)dictionaryFromUserStatisticsConfigPlist{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WGlobalUserStatisticsConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end
