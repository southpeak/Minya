//
//  TopImageView.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "TopImageView.h"
#import "TopImagePipeline.h"
#import "Minya.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TopImageView ()

@property (nonatomic, strong) TopImagePipeline *pipeline;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TopImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10.0f);
            make.right.equalTo(@-10.0f);
            make.top.equalTo(self);
            make.height.equalTo(@50.0f);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.equalTo(@150.0f);
        }];
    }
    return self;
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
    
    [self mi_updateView];
    
    @weakify(self)
    [MIObserve(self.pipeline, url) changed:^(id  _Nonnull newValue) {
        @strongify(self)
        [self mi_updateView];
    }];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 200.0f);
}

- (void)mi_updateView {
    self.titleLabel.text = self.pipeline.title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.pipeline.url]];
}

#pragma mark -

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20.0f];
        _titleLabel.textColor = [UIColor blueColor];
        _titleLabel.text = @"Empty Image";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
