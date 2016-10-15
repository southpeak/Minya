//
//  UIView+MIPipeline.h
//  MinyaDemo
//
//  Created by Konka on 2016/9/27.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIPipeline.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  UIView+MIPipeline Category
 *
 *  UIView category for pipeline
 */
@interface UIView (MIPipeline)

/**
 *  Set up the view's pipeline
 *
 *  @param pipeline pipeline for current view
 */
- (void)setupPipeline:(__kindof MIPipeline * _Nonnull)pipeline;

@end

NS_ASSUME_NONNULL_END
