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

@interface PhotoListViewController ()

@property (nonatomic, strong) PhotoListPipeline *pipeline;

@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo List";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.store fetchData];
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
}

- (void)addObservers {
    
    @weakify(self)
    
    [MIObserve(self.pipeline, inputSelectedPhotoIndex) changed:^(id  _Nonnull newValue) {
        
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

#pragma mark - 



@end
