//
//  ResultListStore.h
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIStore.h"
#import "PhotoListPipeline.h"

@interface PhotoListStore : MIStore

@property (nonatomic, strong, readonly) PhotoListPipeline *photoListPipeline;

@end
