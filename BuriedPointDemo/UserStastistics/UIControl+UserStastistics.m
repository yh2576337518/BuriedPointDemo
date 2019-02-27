//
//  UIControl+UserStastistics.m
//  BuriedPointDemo
//
//  Created by 惠上科技 on 2019/2/26.
//  Copyright © 2019 惠上科技. All rights reserved.
//

#import "UIControl+UserStastistics.h"
#import "CommonUtility.h"
#import "EventIDConstant.h"
#import "StastisticsUtility.h"
#import <objc/runtime.h>
@implementation UIControl (UserStastistics)
static char *extraKey = "stastisticExtraKey";

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //原方法
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        //我们要实现的方法
        SEL swizzledSelector = @selector(swiz_sendAction:to:forEvent:);
        //方法交换（具体是现在上面）
        [CommonUtility swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}


#pragma mark --------Method Swizzling
-(void)swiz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    //插入埋点代码
    [self performUserStastisticsAction:action to:target forEvent:event];
    [self swiz_sendAction:action to:target forEvent:event];
}

-(void)performUserStastisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
//    NSLog(@"\n***hook success.\n[1]action:%@\n[2]target:%@ \n[3]event:%ld", NSStringFromSelector(action), target, (long)event);
    NSString *eventID = nil;
    //只统计触摸结束时
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
        NSString *actionString = NSStringFromSelector(action);
        NSString *targetName = NSStringFromClass([target class]);
        NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
        eventID = configDict[targetName][@"ControlEventIDs"][actionString];
    }
    if (eventID != nil) {
        [StastisticsUtility sendEventToServer:eventID];
    }
}

-(NSDictionary *)dictionaryFromUserStatisticsConfigPlist{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WGlobalUserStatisticsConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end
