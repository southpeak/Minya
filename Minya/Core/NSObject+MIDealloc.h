//
//  NSObject+MIDealloc.h
//  MinyaDemo
//
//  Created by 00 on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Category for NSObject's dealloc method swizzling.
 */
@interface NSObject (MIDealloc)

/**
 *  Register a new dealloc handle block for the handleKey.
 *
 *  We will use a block as the new implementation for the dealloc method, and store this block
 *  in a directory for the later swizzling.
 *
 *  @param handleKey            Key for the new block
 *  @param willDeallocHandle    New implementation for the dealloc method
 */
- (void)registerDeallocHandleWithKey:(NSString * _Nonnull)handleKey handle:(void (^)())willDeallocHandle;

@end

NS_ASSUME_NONNULL_END
