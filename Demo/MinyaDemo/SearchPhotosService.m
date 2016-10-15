//
//  SearchPhotosService.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "SearchPhotosService.h"
#import <FlickrKit/FlickrKit.h>

@implementation SearchPhotosService

- (void)requestWithParameters:(NSDictionary *)parameters success:(MIRequestSuccessBlock)success fail:(MIRequestFailBlock)fail {
    
    [[FlickrKit sharedFlickrKit] call:@"flickr.photos.getRecent" args:parameters completion:^(NSDictionary *response, NSError *error) {
        
        NSLog(@"%@", response);
        
        if (!error) {
            NSDictionary *photos = response[@"photos"];
            
            NSArray *photoArray = photos[@"photo"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            [photoArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *photo = @{
                    @"id": [NSString stringWithFormat:@"%@", obj[@"id"] ?: @""],
                    @"title": obj[@"title"] ?: @""
                };
                
                [array addObject:photo];
            }];
            
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            data[@"page"] = photos[@"page"];
            data[@"pages"] = photos[@"pages"];
            data[@"total"] = photos[@"total"];
            data[@"photos"] = array;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(data);
                }
            });
        }
    }];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
