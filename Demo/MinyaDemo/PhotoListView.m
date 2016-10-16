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

#pragma mark - PhotoListView Extension
@interface PhotoListView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) PhotoListPipeline *pipeline;

@property (nonatomic, strong) UITableView *tableView;

@end

#pragma mark - PhotoListView implementation
@implementation PhotoListView

#pragma mark - Inherited Methods
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
    
    // After setting up the pipeline, we should observe some properties we need.
    
    @weakify(self)
    
    // Observe the flag property, and if data has been back from the server,
    // we can refresh the tableview.
    [MIObserve(self.pipeline, flagRequestFinished) changed:^(id  _Nonnull newValue) {
        
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y + self.bounds.size.height > scrollView.contentSize.height - 30.0f) {
        self.pipeline.inputFetchMoreData = YES;
    }
}

#pragma mark - Properties Accessor

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
