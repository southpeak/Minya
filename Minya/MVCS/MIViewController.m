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
@property (nonatomic, copy) MICallback callback;                //!< Callback for the previous ViewController

@end

#pragma mark - MIViewController implementation

@implementation MIViewController

#pragma mark - Life Cycle

- (instancetype)initWithStore:(id<MIStore>)store viewClass:(Class)viewClass {
    
    return [self initWithStore:store viewClass:viewClass callback:nil];
}

- (instancetype)initWithStore:(id<MIStore>)store viewClass:(Class)viewClass callback:(MICallback)callback {
    
    NSParameterAssert(store);
    NSAssert([viewClass isSubclassOfClass:[UIView class]], @"viewClass should be subclass of UIView");
    
    self = [super init];
    
    if (self) {
        
        _store = store;
        _viewClass = viewClass;
        _callback = [callback copy];
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view = [[self.viewClass alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up pipeline
    [self setupPipeline:self.store.pipeline];
    [self.view setupPipeline:self.store.pipeline];
    
    // Add observers of the pipeline data.
    [self addObservers];
}

#pragma mark - Public Methods

- (void)addObservers { }

- (void)setupPipeline:(__kindof MIPipeline *)pipeline { }

@end
