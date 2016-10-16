//
//  PhotoDetailView.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "PhotoDetailView.h"
#import <Masonry/Masonry.h>
#import "PhotoDetailPipeline.h"
#import "Minya.h"

@interface PhotoDetailView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *ownerLabel;
@property (nonatomic, strong) UILabel *takenLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) PhotoDetailPipeline *pipeline;

@end

@implementation PhotoDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.ownerLabel];
        [self addSubview:self.takenLabel];
        [self addSubview:self.descLabel];
        
        [self addSubview:self.prevButton];
        [self addSubview:self.nextButton];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10.0f);
            make.right.equalTo(@-10.0f);
            make.top.equalTo(@100.0f);
        }];
        
        [self.ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10.0f);
        }];
        
        [self.takenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.ownerLabel.mas_bottom).offset(10.0f);
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.takenLabel.mas_bottom).offset(10.0f);
        }];
        
        [self.prevButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15.0f);
            make.width.equalTo(@100.0f);
            make.top.equalTo(self.descLabel.mas_bottom).offset(10.0f);
        }];
        
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15.0f);
            make.width.top.equalTo(self.prevButton);
        }];
    }
    return self;
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    
    self.pipeline = pipeline;
    
    @weakify(self)
    [MIObserve(self.pipeline, flagRequestFinished) changed:^(id  _Nonnull newValue) {
        @strongify(self)
        
        self.titleLabel.text = self.pipeline.photo.title;
        self.descLabel.text = self.pipeline.photo.desc;
        self.takenLabel.text = self.pipeline.photo.taken;
        self.ownerLabel.text = self.pipeline.photo.owner;
    }];
}

#pragma mark - Accessor

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self mi_createLabel];
        _titleLabel.textColor = [UIColor blueColor];
    }
    return _titleLabel;
}

- (UILabel *)ownerLabel {
    if (!_ownerLabel) {
        _ownerLabel = [self mi_createLabel];
        _ownerLabel.textColor = [UIColor greenColor];
    }
    return _ownerLabel;
}

- (UILabel *)takenLabel {
    
    if (!_takenLabel) {
        _takenLabel = [self mi_createLabel];
        _takenLabel.textColor = [UIColor redColor];
    }
    
    return _takenLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [self mi_createLabel];
        _descLabel.textColor = [UIColor yellowColor];
    }
    
    return _descLabel;
}

- (UIButton *)prevButton {
    if (!_prevButton) {
        _prevButton = [self mi_createButtonWithTitle:@"Prev"];
    }
    return _prevButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [self mi_createButtonWithTitle:@"Next"];
    }
    return _nextButton;
}

- (UILabel *)mi_createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    return label;
}

- (UIButton *)mi_createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 1.0f;
    
    [button addTarget:self action:@selector(mi_tapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)mi_tapButton:(UIButton *)sender {
    
    if (sender == self.prevButton) {
        self.pipeline.inputPrev = YES;
    } else {
        self.pipeline.inputNext = YES;
    }
}

@end
