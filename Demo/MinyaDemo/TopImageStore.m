//
//  TopImageStore.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "TopImageStore.h"
#import "Minya.h"

#pragma mark - TopImageStore Extension

@interface TopImageStore ()

@property (nonatomic, strong, readwrite) TopImagePipeline *imagePipeline;       // Pipeline
@property (nonatomic, strong) id<MIService> getSizesService;                    // Service

@end

#pragma mark - TopImageStore implementation

@implementation TopImageStore

#pragma mark - Inherited Methods

- (void)fetchData {
    
    if (!self.imagePipeline.photoID || [self.imagePipeline.photoID isEqualToString:@"0"]) {
        return;
    }
    
    @weakify(self)
    [self.getSizesService requestWithParameters:@{@"photo_id": self.imagePipeline.photoID} success:^(NSString * _Nullable data) {
        @strongify(self)
        self.imagePipeline.url = data;
    } fail:^(id  _Nullable data, NSError * _Nullable error) {
        // You can do something if the request failed.
    }];
}

- (__kindof MIPipeline *)pipeline {
    return self.imagePipeline;
}

- (void)addObservers {
    
    @weakify(self)
    
    // Observe the `photoID` property of the imagePipeline and then
    // fetch the photo's information from the server
    [MIObserve(self.imagePipeline, photoID) changed:^(NSString * _Nonnull newValue) {
        @strongify(self)
        [self fetchData];
    }];
}

#pragma mark - Properties Accessor

- (TopImagePipeline *)imagePipeline {
    if (!_imagePipeline) {
        _imagePipeline = [[TopImagePipeline alloc] init];
        
        // Add observers here is to make sure that the pipeline is not nil.
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
