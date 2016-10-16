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

#pragma mark - InterestingnessStore Extension

@interface InterestingnessStore ()

@property (nonatomic, strong) InterestingnessPipeline *interestPipeline;    // Pipeline

// If you business is complicated, we suggest that you distribute
// you business logic code to different sub store. One store handles
// one business logic. And the communication between is the
// responsibility of the pipeline.
//
// Another thing. We reuse the PhotoListStore and PhotoListView, but not
// reuse the PhotoListViewController.
@property (nonatomic, strong) TopImageStore *imageStore;                    // Top image store
@property (nonatomic, strong) PhotoListStore *photoStore;                   // Photo List store

@property (nonatomic, assign) BOOL isFirst;

@end

#pragma mark - InterestingnessStore implementation

@implementation InterestingnessStore

#pragma mark - Inherited Methods

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
    
    // Observe the `flagRequestFinished` of `photoListPipeline`,
    // and if it is the first time to request data, we will update
    // the imagePipeline's `photoID` property. The TopImageStore observe
    // `photoID` and it will request the photo' url information.
    [MIObserve(self.interestPipeline.photoListPipeline, flagRequestFinished) changed:^(id  _Nonnull newValue) {
        @strongify(self)
        if (self.isFirst) {
            [self.interestPipeline setShowImageAtIndex:0];
            self.isFirst = NO;
        }
    }];
    
    // Observe the `inputSelectedPhotoIndex` of `photoListPipeline`(user select the cell in the table view).
    // We will update the the imagePipeline's `photoID` property. The later step is same as the
    // observing for the `flagRequestFinished` property.
    [MIObserve(self.interestPipeline.photoListPipeline, inputSelectedPhotoIndex) changed:^(NSNumber * _Nonnull newValue) {
        
        @strongify(self)
        [self.interestPipeline setShowImageAtIndex:[newValue integerValue]];
    }];
}

+ (NSArray<NSString *> *)requiredParameters {
    return @[@"photo"];
}

#pragma mark - Properties Accessor

- (InterestingnessPipeline *)interestPipeline {
    if (!_interestPipeline) {
        _interestPipeline = [[InterestingnessPipeline alloc] init];
        
        // Create pipeline hierarchy, you must make sure that the sub pipeline
        // is not nil, otherwise the subview will not observe the corresponding pipeline.
        _interestPipeline.imagePipeline = self.imageStore.imagePipeline;
        _interestPipeline.photoListPipeline = self.photoStore.photoListPipeline;
    }
    return _interestPipeline;
}

@end
