//
//  ResultListView.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "PhotoListView.h"
#import "PhotoListPipeline.h"
#import "UIView+MIPipeline.h"
#import "Minya.h"
#import <Masonry/Masonry.h>

@interface PhotoListView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) PhotoListPipeline *pipeline;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PhotoListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
    
    @weakify(self)
    
    [MIObserve(self.pipeline, flagRequestFinished) changed:^(id  _Nonnull changedValue) {
        
        @strongify(self)
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.pipeline.inputSelectedPhotoIndex = indexPath.row;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pipeline.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewCell"];
    
    NSDictionary *photo = self.pipeline.photos[indexPath.row];
    cell.textLabel.text = photo[@"title"];
    
    return cell;
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y + self.bounds.size.height > scrollView.contentSize.height - 30.0f) {
        self.pipeline.inputFetchMoreData = YES;
    }
}

#pragma mark - 

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ViewCell"];
    }
    
    return _tableView;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
