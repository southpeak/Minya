//
//  NSObject+MINotification.m
//  MinyaDemo
//
//  Created by 00 on 2016/11/2.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "NSObject+MINotification.h"
#import "NSObject+MIDealloc.h"
#import <objc/runtime.h>

static const void *kMINotificationInfoKey = &kMINotificationInfoKey;

#pragma mark - __MINotificationInfo

/**
 __MINotificationInfo class
 
 This is a private class that represent an notification.
 */
@interface __MINotificationInfo : NSObject

@property (nonatomic, unsafe_unretained) id sender;
@property (nonatomic, copy) NSString *notificationName;
@property (nonatomic, copy) MINotificationBlock handler;

@end

@implementation __MINotificationInfo

- (NSUInteger)hash {
    NSString *target = [NSString stringWithFormat:@"%@_%@", [self.sender description], self.notificationName];
    return target.hash;
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        return YES;
    }
    
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    
    __MINotificationInfo *tempInfo = (__MINotificationInfo *)object;
    
    NSString *target = [NSString stringWithFormat:@"%@_%@", [self.sender description], self.notificationName];
    NSString *tempTarget = [NSString stringWithFormat:@"%@_%@", [tempInfo.sender description], self.notificationName];
    
    return [target isEqualToString:tempTarget];
}

@end

#pragma mark - NSObject MINotification Category

@implementation NSObject (MINotification)

- (void)observeNotification:(NSString *)notificationName sender:(id)sender handler:(MINotificationBlock)handler {
    
    NSParameterAssert(notificationName);
    NSParameterAssert(handler);
    
    __MINotificationInfo *info = [self mi_createNotificationInfoWithNotification:notificationName
                                                                          sender:sender
                                                                         handler:handler];
    
    NSMutableSet *infos = [self mi_notificationInfos];
    if ([infos containsObject:info]) {
        return;
    }
    
    [infos addObject:info];
    
    __unsafe_unretained id unretainedSelf = self;
    [self registerDeallocHandleWithKey:@"mi_notificationHandler" handle:^{
        [[NSNotificationCenter defaultCenter] removeObserver:unretainedSelf];
    }];
    
    if (sender != self) {
        __unsafe_unretained id unretainedSender = sender;
        [sender registerDeallocHandleWithKey:@"mi_notificationHandler" handle:^{
            
            [[unretainedSelf mi_notificationInfos] enumerateObjectsUsingBlock:^(__MINotificationInfo * _Nonnull info, BOOL * _Nonnull stop) {
                
                if (info.sender == unretainedSelf) {
                    [[NSNotificationCenter defaultCenter] removeObserver:unretainedSelf name:nil object:unretainedSender];
                }
            }];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mi_handleNotification:)
                                                 name:notificationName
                                               object:sender];
}

- (void)removeNotification:(NSString *)notificationName {
    
    NSMutableSet *infos = [self mi_notificationInfos];
    
    __block __MINotificationInfo *needDeleteInfo = nil;
    [infos enumerateObjectsUsingBlock:^(__MINotificationInfo * _Nonnull info, BOOL * _Nonnull stop) {
        
        if ([info.notificationName isEqualToString:notificationName]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:info.notificationName object:nil];
            needDeleteInfo = info;
            *stop = YES;
        }
    }];
    
    if (needDeleteInfo) {
        [infos removeObject:needDeleteInfo];
    }
}

#pragma mark - Private Methods

/**
 Create an __MINotificationInfo instance

 @param notificationName notification name
 @param sender notification sender
 @param handler handler callback
 
 @return __MINotificationInfo instance
 */
- (__MINotificationInfo *)mi_createNotificationInfoWithNotification:(NSString *)notificationName
                                                             sender:(id)sender
                                                            handler:(MINotificationBlock)handler {
    
    __MINotificationInfo *info = [[__MINotificationInfo alloc] init];
    info.sender = sender;
    info.notificationName = notificationName;
    info.handler = handler;
    
    return info;
}

/**
 Handle notification

 @param notification notification information
 */
- (void)mi_handleNotification:(NSNotification *)notification {
    
    NSSet *infos = [self mi_notificationInfos];
    [infos enumerateObjectsUsingBlock:^(__MINotificationInfo * _Nonnull info, BOOL * _Nonnull stop) {
        if ([info.notificationName isEqualToString:notification.name]) {
            if (!info.sender || info.sender == notification.object) {
                info.handler(notification);
                *stop = YES;
            }
        }
    }];
}

/**
 Get the notification informations of current object.

 @return a set that contains all the notification informations
 */
- (NSMutableSet *)mi_notificationInfos {
    
    NSMutableSet *infos = objc_getAssociatedObject(self, kMINotificationInfoKey);
    if (!infos) {
        infos = [[NSMutableSet alloc] init];
        [self mi_setNotificationInfos:infos];
    }
    
    return infos;
}

/**
 Set the notification informations of current object.

 @param infos notification informations.
 */
- (void)mi_setNotificationInfos:(NSMutableSet *)infos {
    
    objc_setAssociatedObject(self, kMINotificationInfoKey, infos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
