//
//  NSObject+MISwizzle.m
//  MinyaDemo
//
//  Created by 00 on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "NSObject+MISwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (MISwizzle)

+ (void)swizzleOriginalSelector:(SEL)originalSelector targetSelector:(SEL)targetSelector {
    
    NSParameterAssert(originalSelector);
    NSParameterAssert(targetSelector);
    
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method targetMethod = class_getInstanceMethod([self class], targetSelector);
    
    if (!originalMethod || !targetMethod) {
        return;
    }
    
    // Try to add a new method to the class.
    // The method's selector is the originalSelector,
    // and the implementation is targetMethod
    BOOL success = class_addMethod([self class],
                                   originalSelector,
                                   method_getImplementation(targetMethod),
                                   method_getTypeEncoding(targetMethod));
    
    // If adding method is success, we replace the target method's implementation
    // with the original method implementation;
    // else we will exchange the implementations directly.
    if (success) {
        class_replaceMethod([self class],
                            targetSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, targetMethod);
    }
}

@end
