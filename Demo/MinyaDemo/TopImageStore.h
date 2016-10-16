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

// In general, we declare a pipeline property in the .m file.
// You declare it in the .h file only when you create a
// pipeline hierarchy.
@property (nonatomic, strong, readonly) TopImagePipeline *imagePipeline;

@end
