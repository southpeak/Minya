//
//  RootView.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "SearchView.h"
#import "SearchPipeline.h"
#import <Masonry/Masonry.h>

@interface SearchView ()

@property (nonatomic, strong) SearchPipeline *pipeline;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *interestingButton;

@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.searchBar];
        [self addSubview:self.searchButton];
        [self addSubview:self.interestingButton];
        
        [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(@64.0f);
        }];
        
        [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100.0f);
            make.centerX.equalTo(self);
            make.top.equalTo(self.searchBar.mas_bottom).offset(10.0f);
        }];
        
        [self.interestingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10.0f);
            make.right.equalTo(@-10.0f);
            make.centerX.equalTo(self);
            make.top.equalTo(self.searchButton.mas_bottom).offset(50.0f);
        }];
    }
    return self;
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
}

#pragma mark -

- (void)mi_tapButton:(UIButton *)button {
    
    if (![self.searchBar.text isEqualToString:@""]) {
        self.pipeline.inputSearchText = self.searchBar.text;
        self.pipeline.inputSearch = YES;
    }
}

- (void)mi_tapInterestingButton:(UIButton *)button {
    
    if (![self.searchBar.text isEqualToString:@""]) {
        self.pipeline.inputSearchText = self.searchBar.text;
        self.pipeline.inputInterest = YES;
    }
}

#pragma mark - Accessor

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
    }
    
    return _searchBar;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setBackgroundColor:[UIColor blueColor]];
        [_searchButton setTitle:@"GO" forState:UIControlStateNormal];
        
        [_searchButton addTarget:self action:@selector(mi_tapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _searchButton;
}

- (UIButton *)interestingButton {
    if (!_interestingButton) {
        _interestingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_interestingButton setBackgroundColor:[UIColor blueColor]];
        [_interestingButton setTitle:@"Search & Show Selected Image" forState:UIControlStateNormal];
        
        [_interestingButton addTarget:self action:@selector(mi_tapInterestingButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _interestingButton;
}

@end
