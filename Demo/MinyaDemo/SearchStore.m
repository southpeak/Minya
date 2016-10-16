//
//  RootStore.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "SearchStore.h"
#import "SearchPipeline.h"

@interface SearchStore ()

// Declare a pipeline object
@property (nonatomic, strong, nullable) SearchPipeline *searchPipeline;

@end


@implementation SearchStore

- (__kindof MIPipeline *)pipeline {
    return self.searchPipeline;
}

#pragma mark - Accessor

- (SearchPipeline *)searchPipeline {
    if (!_searchPipeline) {
        _searchPipeline = [[SearchPipeline alloc] init];
    }
    
    return _searchPipeline;
}

@end
