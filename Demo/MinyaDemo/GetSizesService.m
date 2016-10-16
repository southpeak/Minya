//
//  GetSizesService.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "GetSizesService.h"
#import <FlickrKit/FlickrKit.h>

@implementation GetSizesService

- (void)requestWithParameters:(NSDictionary *)parameters success:(MIRequestSuccessBlock)success fail:(MIRequestFailBlock)fail {
    
    [[FlickrKit sharedFlickrKit] call:@"flickr.photos.getSizes" args:parameters completion:^(NSDictionary *response, NSError *error) {
        
        NSLog(@"%@", response);
        
        if (!error) {
            NSDictionary *sizeDic = [response objectForKey:@"sizes"];
            NSArray *sizes = sizeDic[@"size"];
            
            __block NSString *url = nil;
            [sizes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([@[@100, @150, @200] containsObject:@([obj[@"height"] integerValue])]) {
                    url = obj[@"source"];
                    *stop = YES;
                }
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(url);
                }
            });
        }
    }];
}

@end
