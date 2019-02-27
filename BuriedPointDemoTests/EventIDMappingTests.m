//
//  EventIDMappingTests.m
//  BuriedPointDemoTests
//
//  Created by 惠上科技 on 2019/2/27.
//  Copyright © 2019 惠上科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
@interface EventIDMappingTests : XCTestCase

@end

@implementation EventIDMappingTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


/**
 测试page_action_eventID是否匹配
 能够及时发现函数名称被改变导致点击事件被runtime忽略的情况
 */
-(void)testIfUserStatisticsConfigPlistValid{
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    XCTAssertNotNil(configDict,@"WGlobalUserStatisticsConfig.plist加载失败");
    
    [configDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        XCTAssert([obj isKindOfClass:[NSDictionary class]],@"plist文件结构可能已经改变，请确认");
        NSString *targetPageName = key;
        Class pageClass = NSClassFromString(targetPageName);
        id pageInstance = [[pageClass alloc] init];
        
        //一个pageDict对应一个界面，存放pageID，所有的action及对应的eventID
        NSDictionary *pageDict = (NSDictionary *)obj;
        
        //页面配置信息
        NSDictionary *pageEventIDDict = pageDict[@"PageEventIDs"];
        
        //交互配置信息
        NSDictionary *controlEventIDDict = pageDict[@"ControlEventIDs"];
        
        XCTAssert(pageEventIDDict,@"plist文件未包含PageID字段或者该字段值为空");
        XCTAssert(controlEventIDDict,@"plist文件未包含EventIDs字段或者该字段值为空");
        
        [pageEventIDDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            XCTAssert([obj isKindOfClass:[NSString class]],@"plist文件结构可能已经改变，请确认");
            XCTAssertNotNil(obj,@"EVENT_ID为空，请确认");
        }];
        
        
        [controlEventIDDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            XCTAssert([obj isKindOfClass:[NSString class]],@"plist文件结构可能已经改变，请确认");
            NSString *actionName = key;
            SEL actionSel = NSSelectorFromString(actionName);
            XCTAssert([pageInstance respondsToSelector:actionSel],@"代码与plist文件函数不匹配，请确认：-[%@ %@]", targetPageName, actionName);
            
            //EVENT_ID 不能为空
            XCTAssertNotNil(obj, @"EVENT_ID为空，请确认");
        }];
    }];
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WGlobalUserStatisticsConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}
@end
