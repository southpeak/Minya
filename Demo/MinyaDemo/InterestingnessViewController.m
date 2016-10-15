//
//  InterestingViewController.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "InterestingnessViewController.h"
#import "InterestingnessPipeline.h"
#import "Minya.h"

@interface InterestingnessViewController ()

@property (nonatomic, strong) InterestingnessPipeline *pipeline;

@end

@implementation InterestingnessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Interesting List";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.store fetchData];
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
}

@end
