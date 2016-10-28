//
//  MIMediator.m
//  MinyaDemo
//
//  Created by Konka on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIMediator.h"
#import "MIScene.h"
#import "MIViewController.h"
#import "MIStore.h"

@implementation MIMediator

#pragma mark - Life Cycle

+ (instancetype)sharedMediator {
    
    static MIMediator *mediator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[MIMediator alloc] init];
    });
    
    return mediator;
}

#pragma mark - Scene

- (UIViewController *)viewControllerWithScene:(MIScene *)scene context:(NSDictionary<NSString *,id> *)context {
    
    return [self viewControllerWithScene:scene context:context callback:nil];
}

- (UIViewController *)viewControllerWithScene:(MIScene *)scene context:(NSDictionary<NSString *,id> *)context callback:(MICallback)callback {
    
    NSParameterAssert(scene);
    
    // Check if the controller class is subclass of MIViewController
    Class controllerClass = NSClassFromString(scene.controllerName);
    NSAssert([controllerClass isSubclassOfClass:[MIViewController class]],
             @"%@ is not subclass of MIViewController", scene.controllerName);
    
    // Check if the store and view is valid
    Class storeClass = NSClassFromString(scene.storeName);
    NSAssert([storeClass conformsToProtocol:@protocol(MIStore)],
             @"%@ is not conform to MIStore Protocol", scene.storeName);
    
    Class viewClass = NSClassFromString(scene.viewName);
    NSAssert([viewClass isSubclassOfClass:[UIView class]],
             @"%@ is not a subclass of UIView", scene.viewName);
    
    id<MIStore> store = [[storeClass alloc] initWithContext:context];
    
    return [[controllerClass alloc] initWithStore:store viewClass:viewClass callback:callback];
}

@end
