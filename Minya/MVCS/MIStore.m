//
//  MIStore.m
//  MinyaDemo
//
//  Created by Konka on 2016/9/27.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIStore.h"
#import "MIPipeline.h"

#pragma mark - MIStore implementation

@implementation MIStore

- (instancetype)initWithContext:(NSDictionary<NSString *, id> *)context {
    
    self = [super init];
    
    if (self) {
        
        NSAssert([self.class mi_checkContext:context],
                 @"The context for the %@ should container all the keys in [%@]", NSStringFromClass([self class]), [[self.class requiredParameters] componentsJoinedByString:@","]);
        
        _context = context;
        
//        [self addObservers];
    }
    
    return self;
}

- (void)addObservers {
    
}

#pragma mark - Check Method

+ (NSArray<NSString *> *)requiredParameters {
    return nil;
}

#pragma mark - MIStore Protocol

- (MIPipeline *)pipeline {
    @throw [NSException exceptionWithName:@"MinyaStroeException"
                                   reason:[NSString stringWithFormat:@"【%s】You must implement `-pipeline` method in the subclass of MIStore", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (void)fetchData { }

#pragma mark - Private Methods

// Check that if all the required parameter keys in the context.
// if not, return NO; else return YES
+ (BOOL)mi_checkContext:(NSDictionary<NSString *, id> *)context {
    
    NSArray<NSString *> *keys = context.allKeys;
    
    for (NSString *parameter in [self requiredParameters]) {
        if (![keys containsObject:parameter]) {
            return NO;
        }
    }
    
    return YES;
}

@end
