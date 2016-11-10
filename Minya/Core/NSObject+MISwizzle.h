//
//  NSObject+MISwizzle.h
//  MinyaDemo
//
//  Created by 00 on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Category for NSObject's method swizzling
 */
@interface NSObject (MISwizzle)

/**
 *  swizzling method implementations of original selector and target selector
 *  
 *  @param originalSelector original selector
 *  @param targetSelector target selector
 */
+ (void)swizzleOriginalSelector:(SEL _Nonnull)originalSelector targetSelector:(SEL _Nonnull)targetSelector;

@end

NS_ASSUME_NONNULL_END
