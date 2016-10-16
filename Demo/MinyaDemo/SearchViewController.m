//
//  RootViewController.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchPipeline.h"
#import "Minya.h"

@interface SearchViewController ()

@property (nonatomic, strong) SearchPipeline *pipeline;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Search Photo";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
}

- (void)addObservers {
    
    @weakify(self)
    
    // Observe the input action and then do some work
    [MIObserve(self.pipeline, inputSearch) changed:^(id _Nonnull newValue) {
        
        @strongify(self)
        
        MIScene *scene = [MIScene sceneWithView:@"PhotoListView"
                                     controller:@"PhotoListViewController"
                                          store:@"PhotoListStore"];
        UIViewController *viewController = [[MIMediator sharedMediator] viewControllerWithScene:scene context:self.pipeline.contextForSearch];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    [MIObserve(self.pipeline, inputInterest) changed:^(id  _Nonnull newValue) {
        
        @strongify(self)
        
        MIScene *scene = [MIScene sceneWithView:@"InterestingnessView"
                                     controller:@"InterestingnessViewController"
                                          store:@"InterestingnessStore"];
        UIViewController *viewController = [[MIMediator sharedMediator] viewControllerWithScene:scene context:self.pipeline.contextForSearch];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
}

@end
