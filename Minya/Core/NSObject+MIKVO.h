//
//  NSObject+MIKVO.h
//  MinyaDemo
//
//  Created by 00 on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTKeyPathCoding.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Macro

/**
 *  A macro for Observing an object's property
 *
 *  We recommend use this macro to observe an object's property change and
 *  then call the handle method, for example:
 *
 *  [MIObserver(user, name) handle:^(id newValue) {
 *      NSLog(@"%@", newValue)
 *  }];
 *
 *  @param TARGET  observed object
 *  @param KEYPATH property's keypath
 *
 */
#define MIObserve(TARGET, KEYPATH) \
[self observe:(id)(TARGET) forKeyPath:@keypath(TARGET, KEYPATH)]

#pragma mark - Block Type

typedef void(^MIKVOChangedBlock)(id _Nonnull newValue);

#pragma mark - KVO Category for NSObject

/**
 *  Category for NSObject's KVO
 */
@interface NSObject (MIKVO)

/**
 *  Observe an object's property
 *
 *  This method is the complete method for observing an object's property change.
 *  However, this method is a little long-winded, so we recommend you using the 
 *  MIObserve(TARGET, KEYPATH) macro.
 *
 *  @param observedObject Observed object
 *  @param keyPath        Key path for the property
 *  @param changed        Handler callback when property changed
 *
 *  @note the message sender is the observing object, not the observed object.
 */
- (void)observe:(NSObject * _Nullable)observedObject forKeyPath:(NSString * _Nonnull)keyPath changed:(MIKVOChangedBlock _Nullable)changed;

/**
 *  Create an observing object that observe an object's property
 *
 *  @param observedObject Observed object
 *  @param keyPath        Key path for the property
 *
 *  @return An __MIKVOInfo object.
 *
 *  @note   1. The message sender is the observing object, not the observed object.
 *          2. The class(__MIKVOInfo) of the return value is a private class, so we just return id type.
 */
- (id _Nullable)observe:(NSObject * _Nullable)observedObject forKeyPath:(NSString * _Nonnull)keyPath;

/**
 *  Callback for the property value changed.
 *
 *  @param changed  Handler callback when property changed
 *
 *  @note We recommend that you don't call the method directly, 
 *        you should call it with MIObserve(TARGET, KEYPATH) macro.
 */
- (void)changed:(MIKVOChangedBlock _Nullable)changed;

@end

NS_ASSUME_NONNULL_END
