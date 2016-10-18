//
//  NSObject+MIKVO.m
//  MinyaDemo
//
//  Created by 00 on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "NSObject+MIKVO.h"
#import "NSObject+MIDealloc.h"
#import <objc/runtime.h>

static NSString * const kMIKVOInfoKey = @"MIKVOInfoKey";

#pragma mark - __MIAssociated Category for NSObject

@interface NSObject (__MIAssociated)

- (void)mi_setAssociatedObject:(id)object forKey:(NSString *)key;
- (id)mi_associatedObjectForKey:(NSString *)key;

@end

@implementation NSObject (__MIAssociated)

- (void)mi_setAssociatedObject:(id)object forKey:(NSString *)key {
    
    if (!key) {
        return;
    }
    
    objc_setAssociatedObject(self, (__bridge const void *)key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)mi_associatedObjectForKey:(NSString *)key {
    
    if (!key) {
        return nil;
    }
    
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

@end

#pragma mark - __MIKVOInfo

/**
 *  __MIKVOInfo class
 *
 *  This is is just a data structure that contains the kvo infomations.
 */
@interface __MIKVOInfo : NSObject

@property (nonatomic, unsafe_unretained) NSObject *observedObject;      //!< Observed object
@property (nonatomic, unsafe_unretained) NSObject *observingObject;     //!< Observing object
@property (nonatomic, copy) NSString *keyPath;                          //!< Key path
@property (nonatomic, copy) MIKVOChangedBlock changed;                  //!< Handle block for the value changed

@end

@implementation __MIKVOInfo

@end

#pragma mark - MIKVO
@implementation NSObject (MIKVO)

- (void)observe:(NSObject *)observedObject forKeyPath:(NSString *)keyPath changed:(MIKVOChangedBlock)changed {
    
    if (!observedObject) {
        return;
    }
    
    __MIKVOInfo *info = [self mi_createKVOInfoWithObserved:observedObject forKeyPath:keyPath changed:changed];
    [self mi_registerKVOWithInfo:info];
}

- (id)observe:(NSObject *)observedObject forKeyPath:(NSString *)keyPath {
    
    if (!observedObject) {
        return nil;
    }
    
    __MIKVOInfo *info = [self mi_createKVOInfoWithObserved:observedObject forKeyPath:keyPath changed:nil];
    [self mi_registerKVOWithInfo:info];
    
    return info;
}

- (void)changed:(MIKVOChangedBlock)changed {
    if ([self isKindOfClass:[__MIKVOInfo class]]) {
        __MIKVOInfo *info = (__MIKVOInfo *)self;
        info.changed = changed;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    __MIKVOInfo *info = (__bridge __MIKVOInfo *)(context);
    if (info.changed) {
        id newValue = [change valueForKey:NSKeyValueChangeNewKey];
        info.changed([newValue isKindOfClass:[NSNull class]] ? nil : newValue);
    }
}

#pragma mark - Private Methods

/// Create __MIKVOInfo object
- (__MIKVOInfo *)mi_createKVOInfoWithObserved:(NSObject *)observedObject forKeyPath:(NSString *)keyPath changed:(MIKVOChangedBlock)changed {
    
    if (!observedObject) {
        return nil;
    }
    
    __MIKVOInfo *info = [[__MIKVOInfo alloc] init];
    info.observedObject = observedObject;
    info.keyPath = keyPath;
    info.changed = changed;
    info.observingObject = self;
    
    return info;
}

/// Register KVO
- (void)mi_registerKVOWithInfo:(__MIKVOInfo *)info {
    
    if (!info) {
        return;
    }
    
    // Bind the kvo information to the observing object
    [self mi_bindKVOInfo:info withObject:self];
    
    // Bind the kvo information to the observed object
    // if the observed object is not the current object
    if (info.observedObject != self) {
        [self mi_bindKVOInfo:info withObject:info.observedObject];
    }
    
    [info.observedObject addObserver:self
                          forKeyPath:info.keyPath
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
                             context:(__bridge void *)info];
}

/// Bind KVO Info to the observing object
- (void)mi_bindKVOInfo:(__MIKVOInfo *)info withObject:(NSObject *)targetObject {
    
    if (!info || !targetObject) {
        return;
    }
    
    // Add the KVO information to the target object's kvo list.
    NSMutableArray *infos = [targetObject mi_associatedObjectForKey:kMIKVOInfoKey];
    if (!infos) {
        infos = [[NSMutableArray alloc] init];
        [targetObject mi_setAssociatedObject:infos forKey:kMIKVOInfoKey];
    }
    [infos addObject:info];
    
    [self mi_kvo_registerDeallocHandleForObject:targetObject];
}

/// Register a new dealloc implementation for the target object.
- (void)mi_kvo_registerDeallocHandleForObject:(NSObject *)targetObject {
    
    __unsafe_unretained NSObject *registeredObject = targetObject;
    [registeredObject registerDeallocHandleWithKey:@"mi_kvo_dealloc" handle:^{
        
        // When dealloc the target object, we should remove all the kvo information.
        // We swizzle the object's dealloc method to make sure the kvo imformation removed automatically.
        NSArray *infos = [registeredObject mi_associatedObjectForKey:kMIKVOInfoKey];
        [infos enumerateObjectsUsingBlock:^(__MIKVOInfo * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // Remove KVO information
            [info.observedObject removeObserver:info.observingObject forKeyPath:info.keyPath];
            
            // At the same time, we should remove the kvo information of the another object
            // that is in the pair (observed object, observing object).
            NSObject *otherObject = nil;
            if (info.observedObject != registeredObject) {
                otherObject = info.observedObject;
            } else if (info.observingObject != registeredObject) {
                otherObject = info.observingObject;
            }
            
            NSMutableArray *infosForOtherObject = [otherObject mi_associatedObjectForKey:kMIKVOInfoKey];
            [infosForOtherObject removeObject:info];
        }];
    }];
}

@end
