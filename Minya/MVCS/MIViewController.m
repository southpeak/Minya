//
//  MIViewController.m
//  MinyaDemo
//
//  Created by Konka on 2016/9/27.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIViewController.h"
#import "MIStore.h"
#import "UIView+MIPipeline.h"

#pragma mark - MIViewController Extension

@interface MIViewController ()

@property (nonatomic, assign) Class viewClass;                  //!< Container view class
@property (nonatomic, strong, readwrite) UIView *containerView;

@end

#pragma mark - MIViewController implementation

@implementation MIViewController

#pragma mark - Life Cycle

- (instancetype)initWithStore:(id<MIStore>)store viewClass:(Class)viewClass {
    
    NSParameterAssert(store);
    NSAssert([viewClass isSubclassOfClass:[UIView class]], @"viewClass should be subclass of UIView");
    
    self = [super init];
    
    if (self) {
        
        _store = store;
        _viewClass = viewClass;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Build the view hierarchy
    self.containerView = [[self.viewClass alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.containerView];
    
    // Set up pipeline
    [self setupPipeline:self.store.pipeline];
    [self.containerView setupPipeline:self.store.pipeline];
    
    // Add observers of the pipeline data.
    [self addObservers];
}

#pragma mark - Public Methods

- (void)addObservers { }

- (void)setupPipeline:(__kindof MIPipeline *)pipeline { }

@end
