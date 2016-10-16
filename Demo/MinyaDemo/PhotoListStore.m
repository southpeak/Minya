//
//  ResultListStore.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "PhotoListStore.h"
#import "Minya.h"

#pragma mark - PhotoListStore Extension

@interface PhotoListStore ()

@property (nonatomic, strong, readwrite) PhotoListPipeline *photoListPipeline;      //!< Pipeline

@property (nonatomic, strong) id<MIService> searchPhotosService;                    //!< Service

// Data that is not needed in the pipeline.
@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, assign) NSUInteger totalPage;
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) BOOL isLoading;

@end

#pragma mark - PhotoListStore implementation

@implementation PhotoListStore

#pragma mark - Inherited Methods

- (instancetype)initWithContext:(NSDictionary<NSString *,id> *)context {
    
    self = [super initWithContext:context];
    
    if (self) {
        
        self.photoName = context[@"photo"] ?: @"";
        self.pageNumber = 1;
        self.totalPage = 0;
        self.pageSize = 50;
        
        [self addObservers];
    }
    
    return self;
}

- (void)fetchData {
    
    [self mi_requestPhotos];
}

- (__kindof MIPipeline *)pipeline {
    return self.photoListPipeline;
}

- (void)addObservers {
    
    @weakify(self)
    
    // Observe the input property, and then do some work if the data is changed.
    [MIObserve(self.photoListPipeline, inputFetchMoreData) changed:^(id  _Nonnull newValue) {
        
        @strongify(self)
        
        if (self.pageNumber > self.totalPage || self.isLoading) {
            return;
        }
        
        [self mi_requestPhotos];
    }];
}

+ (NSArray<NSString *> * _Nullable)requiredParameters {
    
    return @[@"photo"];
}

#pragma mark - Private Method

- (void)mi_requestPhotos {
    
    // Set up the parameters which will be passed to the service layer.
    NSDictionary *parameters = @{
        @"page": [NSString stringWithFormat:@"%ld", self.pageNumber],
        @"per_page": [NSString stringWithFormat:@"%ld", self.pageSize]
    };
    
    self.isLoading = YES;
    
    @weakify(self)
    [self.searchPhotosService requestWithParameters:parameters success:^(id  _Nullable data) {
        
        @strongify(self)
        
        if (data[@"photos"]) {
            
            // Store the photo data
            [self.photoListPipeline.photos addObjectsFromArray:data[@"photos"]];
            
            // Update the flag property, and then the object(here is the PhotoListView object)
            // who observes it can do some work.
            self.photoListPipeline.flagRequestFinished = YES;
        }
        
        self.totalPage = [data[@"pages"] integerValue];
        
        self.isLoading = NO;
        
    } fail:^(id  _Nullable data, NSError * _Nullable error) {
        self.isLoading = NO;
    }];
}

#pragma mark - Properties Accessor

- (PhotoListPipeline *)photoListPipeline {
    if (!_photoListPipeline) {
        _photoListPipeline = [[PhotoListPipeline alloc] init];
    }
    
    return _photoListPipeline;
}

- (id<MIService>)searchPhotosService {
    
    if (!_searchPhotosService) {
        _searchPhotosService = [MIService serviceWithName:@"SearchPhotosService"];
    }
    
    return _searchPhotosService;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
