//
//  MIScene.h
//  MinyaDemo
//
//  Created by Konka on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  JDScene class
 *
 *  A scene is actually a view controller.
 *  In Minya MVCS architecture, a scene include three parts:
 *  1. view controller
 *  2. container view
 *  3. store
 *
 *  So, when we create a scene, we should provide the three parts informations.
 *  Here, we just need to provide the name of each part. We can use these
 *  name to create a complete scene
 *
 */
@interface MIScene : NSObject

@property (nonatomic, copy, nonnull) NSString *viewName;             //!< view name
@property (nonatomic, copy, nonnull) NSString *controllerName;       //!< controller name
@property (nonatomic, copy, nonnull) NSString *storeName;            //!< store name

+ (instancetype _Nullable)sceneWithView:(NSString * _Nonnull)viewName controller:(NSString * _Nonnull)controllerName store:(NSString * _Nonnull)storeName;

@end

NS_ASSUME_NONNULL_END
