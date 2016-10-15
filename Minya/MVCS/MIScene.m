//
//  MIScene.m
//  MinyaDemo
//
//  Created by Konka on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIScene.h"

@implementation MIScene

#pragma mark - Class Method
+ (instancetype)sceneWithView:(NSString *)viewName controller:(NSString *)controllerName store:(NSString *)storeName {
    
    NSParameterAssert(viewName);
    NSParameterAssert(controllerName);
    NSParameterAssert(storeName);
    
    MIScene *scene = [[MIScene alloc] init];
    scene.viewName = viewName;
    scene.controllerName = controllerName;
    scene.storeName = storeName;
    
    return scene;
}

@end
