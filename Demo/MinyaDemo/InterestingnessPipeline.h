//
//  InterestingnessPipeline.h
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIPipeline.h"

#import "TopImagePipeline.h"
#import "PhotoListPipeline.h"

@interface InterestingnessPipeline : MIPipeline

@property (nonatomic, strong) TopImagePipeline *imagePipeline;
@property (nonatomic, strong) PhotoListPipeline *photoListPipeline;

- (void)setShowImageAtIndex:(NSUInteger)index;

@end
