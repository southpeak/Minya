//
//  TopImageStore.h
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIStore.h"
#import "TopImagePipeline.h"

@interface TopImageStore : MIStore

@property (nonatomic, strong, readonly) TopImagePipeline *imagePipeline;

@end
