//
//  StastisticsUtility.h
//  BuriedPointDemo
//
//  Created by 惠上科技 on 2019/2/26.
//  Copyright © 2019 惠上科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StastisticsUtility : NSObject

/**
 初始化配置，一般在launchWithOption中调用
 */
+(void)configure;
+(void)enterPageViewWithPageID:(NSString *)pageID;
+(void)leavePageViewWithPageID:(NSString *)pageID;
+(void)sendEventToServer:(NSString *)eventId;
@end

