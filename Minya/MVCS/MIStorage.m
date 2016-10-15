//
//  MIStorage.m
//  MinyaDemo
//
//  Created by Konka on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIStorage.h"

@implementation MIStorage

+ (id<MIStorage>)storageWithName:(NSString *)storageName {
    
    NSParameterAssert(storageName);
    
    Class storageClass = NSClassFromString(storageName);
    
    if (!storageClass) {
        return nil;
    }
    
    NSAssert([storageClass conformsToProtocol:@protocol(MIStorage)] && [storageClass isSubclassOfClass:[MIStorage class]],
             @"%@ class should conform to MIStorage protocol and be the subclass of MIStorage class", storageName);
    
    return [[storageClass alloc] init];
}

@end
