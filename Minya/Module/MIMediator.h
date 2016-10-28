//
//  MIMediator.h
//  MinyaDemo
//
//  Created by Konka on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MIUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@class MIScene;

/**
 *  MIMediator class
 *
 *  MIMediator is the mediator between modules or scenes.
 *  When we want to start a module, or create a scene view controller,
 *  we should use this singleton instance.
 */
@interface MIMediator : NSObject

#pragma mark - Life Cycle

+ (instancetype _Nonnull)sharedMediator;

#pragma mark - Scene

/**
 *  Get a view controller
 *
 *  @param scene      scene infomation
 *  @param context    context for this scene
 *  @param callback   callback block. Now it is unused, it is just prepared for the next version. 
 *
 *  @return view controller
 */
- (UIViewController * _Nullable)viewControllerWithScene:(MIScene * _Nonnull)scene
                                                context:(NSDictionary<NSString *, id> * _Nullable)context
                                               callback:(MICallback _Nullable)callback;

- (UIViewController * _Nullable)viewControllerWithScene:(MIScene * _Nonnull)scene
                                                context:(NSDictionary<NSString *, id> * _Nullable)context;

@end

NS_ASSUME_NONNULL_END
