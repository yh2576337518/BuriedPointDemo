//
//  CommonUtility.h
//  BuriedPointDemo
//
//  Created by 惠上科技 on 2019/2/26.
//  Copyright © 2019 惠上科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CommonUtility : NSObject

+(void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
