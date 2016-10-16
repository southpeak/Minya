//
//  ResultListPipeline.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "PhotoListPipeline.h"

@implementation PhotoListPipeline

- (instancetype)init {
    self = [super init];
    if (self) {
        _photos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSDictionary *)contextForDetail {

    NSDictionary *photo = self.photos[self.inputSelectedPhotoIndex];
    NSDictionary *params = @{
        @"photoID": photo[@"id"],
    };
    
    return params;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
