//
//  InterestingnessStore.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "InterestingnessStore.h"
#import "InterestingnessPipeline.h"
#import "Minya.h"

#import "TopImageStore.h"
#import "PhotoListStore.h"

@interface InterestingnessStore ()

@property (nonatomic, strong) InterestingnessPipeline *interestPipeline;

@property (nonatomic, strong) TopImageStore *imageStore;
@property (nonatomic, strong) PhotoListStore *photoStore;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation InterestingnessStore

- (instancetype)initWithContext:(NSDictionary<NSString *,id> *)context {
    
    self = [super initWithContext:context];
    
    if (self) {
        _imageStore = [[TopImageStore alloc] initWithContext:nil];
        _photoStore = [[PhotoListStore alloc] initWithContext:context];
        
        self.isFirst = YES;
        
        [self addObservers];
    }
    
    return self;
}

- (void)fetchData {
    
    [self.photoStore fetchData];
}

- (__kindof MIPipeline *)pipeline {
    return self.interestPipeline;
}

- (void)addObservers {
    @weakify(self)
    
    [MIObserve(self.interestPipeline.photoListPipeline, flagRequestFinished) changed:^(id  _Nonnull newValue) {
        @strongify(self)
        if (self.isFirst) {
            [self.interestPipeline setShowImageAtIndex:0];
            self.isFirst = NO;
        }
    }];
    
    [MIObserve(self.interestPipeline.photoListPipeline, inputSelectedPhotoIndex) changed:^(NSNumber * _Nonnull newValue) {
        
        @strongify(self)
        [self.interestPipeline setShowImageAtIndex:[newValue integerValue]];
    }];
}

+ (NSArray<NSString *> *)requiredParameters {
    return @[@"photo"];
}

#pragma mark -

- (InterestingnessPipeline *)interestPipeline {
    if (!_interestPipeline) {
        _interestPipeline = [[InterestingnessPipeline alloc] init];
        _interestPipeline.imagePipeline = self.imageStore.imagePipeline;
        _interestPipeline.photoListPipeline = self.photoStore.photoListPipeline;
    }
    return _interestPipeline;
}

@end
