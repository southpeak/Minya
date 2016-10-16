//
//  PhotoDetailStore.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "PhotoDetailStore.h"
#import "PhotoDetailPipeline.h"
#import "Minya.h"

@interface PhotoDetailStore ()

@property (nonatomic, strong) PhotoDetailPipeline *detailPipeline;
@property (nonatomic, copy) NSString *photoID;

@property (nonatomic, strong) id<MIService> searchDetailService;
@property (nonatomic, strong) id<MIService> getPhotoContextService;

@property (nonatomic, strong) NSString *prevID;
@property (nonatomic, strong) NSString *nextID;

@end

@implementation PhotoDetailStore

- (instancetype)initWithContext:(NSDictionary<NSString *,id> *)context {
    
    self = [super initWithContext:context];
    
    if (self) {
        
        self.photoID = context[@"photoID"];
        [self addObservers];
    }
    
    return self;
}

- (void)fetchData {
    
    @weakify(self)
    
    [self.searchDetailService requestWithParameters:@{@"photo_id": self.photoID ?: @""} success:^(id  _Nullable data) {
        
        @strongify(self)
        self.detailPipeline.photo = data;
        self.detailPipeline.flagRequestFinished = YES;
        
    } fail:^(id  _Nullable data, NSError * _Nullable error) {
        
    }];
    
    [self.getPhotoContextService requestWithParameters:@{@"photo_id": self.photoID ?: @""} success:^(NSDictionary * _Nullable data) {
        
        @strongify(self)
        
        self.prevID = data[@"prevID"];
        self.nextID = data[@"nextID"];
        
    } fail:^(id  _Nullable data, NSError * _Nullable error) {
        
    }];
}

- (__kindof MIPipeline *)pipeline {
    return self.detailPipeline;
}

- (void)addObservers {
    
    @weakify(self)
    
    [MIObserve(self.detailPipeline, inputPrev) changed:^(id  _Nonnull newValue) {
        @strongify(self)
        
        if (self.prevID && ![self.prevID isEqualToString:@""]) {
            self.photoID = self.prevID;
            [self fetchData];
        }
    }];
    
    [MIObserve(self.detailPipeline, inputNext) changed:^(id  _Nonnull newValue) {
        @strongify(self)
        if (self.nextID && ![self.nextID isEqualToString:@""]) {
            self.photoID = self.nextID;
            [self fetchData];
        }
    }];
}

+ (NSArray<NSString *> * _Nullable)requiredParameters {
    
    return @[@"photoID"];
}

#pragma mark -

- (PhotoDetailPipeline *)detailPipeline {
    if (!_detailPipeline) {
        _detailPipeline = [[PhotoDetailPipeline alloc] init];
    }
    return _detailPipeline;
}

- (id<MIService>)searchDetailService {
    if (!_searchDetailService) {
        _searchDetailService = [MIService serviceWithName:@"SearchPhotoDetailService"];
    }
    return _searchDetailService;
}

- (id<MIService>)getPhotoContextService {
    if (!_getPhotoContextService) {
        _getPhotoContextService = [MIService serviceWithName:@"GetPhotoContextService"];
    }
    return _getPhotoContextService;
}

@end
