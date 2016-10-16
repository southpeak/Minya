//
//  InterestingnessView.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "InterestingnessView.h"
#import "UIView+MIPipeline.h"
#import "InterestingnessPipeline.h"
#import "TopImageView.h"
#import "PhotoListView.h"

#import <Masonry/Masonry.h>

#pragma mark - InterestingnessView extension

@interface InterestingnessView ()

@property (nonatomic, strong) InterestingnessPipeline *pipeline;

@property (nonatomic, strong) TopImageView *topImageView;
@property (nonatomic, strong) PhotoListView *photoListView;

@end

#pragma mark - InterestingnessView implementation

@implementation InterestingnessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImageView];
        [self addSubview:self.photoListView];
        
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0.0f);
            make.top.equalTo(@64.0f);
        }];
        
        [self.photoListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.topImageView.mas_bottom);
        }];
    }
    return self;
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
    
    // Set up the pipeline of the subviews.
    [self.topImageView setupPipeline:self.pipeline.imagePipeline];
    [self.photoListView setupPipeline:self.pipeline.photoListPipeline];
}

#pragma mark - Properties Accessor

- (TopImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[TopImageView alloc] init];
    }
    return _topImageView;
}

- (PhotoListView *)photoListView {
    if (!_photoListView) {
        _photoListView = [[PhotoListView alloc] init];
    }
    return _photoListView;
}

@end
