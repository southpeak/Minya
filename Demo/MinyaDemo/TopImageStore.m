//
//  TopImageStore.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "TopImageStore.h"
#import "Minya.h"

@interface TopImageStore ()

@property (nonatomic, strong, readwrite) TopImagePipeline *imagePipeline;
@property (nonatomic, strong) id<MIService> getSizesService;

@end

@implementation TopImageStore

- (void)fetchData {
    
    if (!self.imagePipeline.photoID || [self.imagePipeline.photoID isEqualToString:@"0"]) {
        return;
    }
    
    @weakify(self)
    [self.getSizesService requestWithParameters:@{@"photo_id": self.imagePipeline.photoID} success:^(NSString * _Nullable data) {
        @strongify(self)
        self.imagePipeline.url = data;
    } fail:^(id  _Nullable data, NSError * _Nullable error) {
        
    }];
}

- (__kindof MIPipeline *)pipeline {
    return self.imagePipeline;
}

- (void)addObservers {
    @weakify(self)
    
    [MIObserve(self.imagePipeline, photoID) changed:^(NSString * _Nonnull changedValue) {
        @strongify(self)
        [self fetchData];
    }];
}

#pragma mark - 

- (TopImagePipeline *)imagePipeline {
    if (!_imagePipeline) {
        _imagePipeline = [[TopImagePipeline alloc] init];
        
        [self addObservers];
    }
    return _imagePipeline;
}

- (id<MIService>)getSizesService {
    if (!_getSizesService) {
        _getSizesService = [MIService serviceWithName:@"GetSizesService"];
    }
    return _getSizesService;
}

@end
