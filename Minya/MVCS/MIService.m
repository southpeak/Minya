//
//  MIService.m
//  MinyaDemo
//
//  Created by Konka on 2016/9/27.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIService.h"

@implementation MIService

#pragma mark - Class Method
+ (id<MIService>)serviceWithName:(NSString *)serviceName {
    
    NSParameterAssert(serviceName);
    
    Class serviceClass = NSClassFromString(serviceName);
    
    if (serviceClass == NULL) {
        return nil;
    }
    
    NSAssert([serviceClass conformsToProtocol:@protocol(MIService)] && [serviceClass isSubclassOfClass:[MIService class]],
             @"%@ class should conform to MIService protocol and be the subclass of MIService class", serviceName);
    
    return [[serviceClass alloc] init];
}

#pragma mark - MIService Protocol
- (void)requestWithParameters:(NSDictionary *)parameters
                      success:(MIRequestSuccessBlock)success
                         fail:(MIRequestFailBlock)fail {
    
    @throw [NSException exceptionWithName:@"MinyaServiceException"
                                   reason:[NSString stringWithFormat:@"【%s】 You must implement `-requestWithParameters:success:fail:` method in the subclass of MIService.", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

@end
