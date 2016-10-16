//
//  ResultListViewController.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoListPipeline.h"
#import "Minya.h"

#pragma mark - PhotoListViewController Extension
@interface PhotoListViewController ()

@property (nonatomic, strong) PhotoListPipeline *pipeline;      //!< Pipeline

@end

#pragma mark - PhotoListViewController implementation
@implementation PhotoListViewController

#pragma mark - Inherited Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo List";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // You should call `fetchData` method at the place where you want
    [self.store fetchData];
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
}

- (void)addObservers {
    
    @weakify(self)
    
    // When user select a cell in the tableview, it will push the next viewcontroller.
    // The view controller observe the action and then do the work.
    [MIObserve(self.pipeline, inputSelectedPhotoIndex) changed:^(id _Nonnull newValue) {
        
        @strongify(self)
        
        MIScene *scene = [MIScene sceneWithView:@"PhotoDetailView"
                                     controller:@"PhotoDetailViewController"
                                          store:@"PhotoDetailStore"];
        
        UIViewController *viewController = [[MIMediator sharedMediator] viewControllerWithScene:scene context:self.pipeline.contextForDetail];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
