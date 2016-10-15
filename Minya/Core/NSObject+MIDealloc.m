//
//  NSObject+MIDealloc.m
//  MinyaDemo
//
//  Created by 00 on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "NSObject+MIDealloc.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const void *kNSObjectWillDeallocHandleDicKey = &kNSObjectWillDeallocHandleDicKey;

/**
 *  __MISwizzledClasses static method
 *
 *  This method return a set that contains all names of the classes whose dealloc is swizzled to new
 *  implementation. The set is a global variable, and we create it with dispatch_once to
 *  guarantee that set is created once in the life of app.
 *
 *  @return A NSMutableSet instance
 */
static NSMutableSet *__MISwizzledClasses() {
    
    static NSMutableSet *swizzledClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    return swizzledClasses;
}

/**
 *  __MISwizzleDeallocIfNeeded static method
 *
 *  This method is used to swizzle the swizzledClass's dealloc implementation.
 *
 *  @param swizzledClass  class whose dealloc implementation should be swizzled.
 */
static void __MISwizzleDeallocIfNeeded(Class swizzledClass) {
    
    @synchronized (__MISwizzledClasses()) {
        
        // Return directly if the dealloc method of the class has been swizzled
        NSString *className = NSStringFromClass(swizzledClass);
        if ([__MISwizzledClasses() containsObject:className]) {
            return;
        }
        
        SEL deallocSelector = sel_registerName("dealloc");
        
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        
        // Block that is the new implementation for the dealloc method.
        id newDealloc = ^(__unsafe_unretained id self) {
            
            // Get all the dealloc handle block and execute all of them.
            NSDictionary *handleDic = objc_getAssociatedObject(self, kNSObjectWillDeallocHandleDicKey);
            [handleDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                void (^willDeallocHandle)() = obj;
                willDeallocHandle();
            }];
            
            objc_setAssociatedObject(self, kNSObjectWillDeallocHandleDicKey, nil, OBJC_ASSOCIATION_ASSIGN);
            
            // Execute the original dealloc method.
            // If the originalDealloc is NULL, execute the super class's dealloc method.
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(swizzledClass)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            } else {
                originalDealloc(self, deallocSelector);
            }
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        
        // Try to add a new method that contains a new dealloc implementation for the dealloc method,
        // if failed, we will update the implementation of the dealloc method.
        if (!class_addMethod(swizzledClass, deallocSelector, newDeallocIMP, "v@:")) {
            
            // The class already contains a method implementation.
            Method deallocMethod = class_getInstanceMethod(swizzledClass, deallocSelector);
            
            // We need to store original implementation before setting new implementation
            // in case method is called at the time of setting.
            originalDealloc = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
            
            // We need to store original implementation again, in case it just changed.
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        
        [__MISwizzledClasses() addObject:className];
    }
}

@implementation NSObject (MIDealloc)

- (void)registerDeallocHandleWithKey:(NSString *)handleKey handle:(void (^)())willDeallocHandle {
    
    @synchronized (self) {
        if (!handleKey || !willDeallocHandle) {
            return;
        }
        
        NSMutableDictionary *handleDic = objc_getAssociatedObject(self, kNSObjectWillDeallocHandleDicKey);
        if (!handleDic) {
            handleDic = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, kNSObjectWillDeallocHandleDicKey, handleDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        handleDic[handleKey] = willDeallocHandle;
        
        __MISwizzleDeallocIfNeeded([self class]);
    }
}

@end
