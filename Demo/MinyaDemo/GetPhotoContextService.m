//
//  GetPhotoContextService.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "GetPhotoContextService.h"
#import <FlickrKit/FlickrKit.h>

@implementation GetPhotoContextService

- (void)requestWithParameters:(NSDictionary *)parameters success:(MIRequestSuccessBlock)success fail:(MIRequestFailBlock)fail {
    
    [[FlickrKit sharedFlickrKit] call:@"flickr.photos.getContext" args:parameters completion:^(NSDictionary *response, NSError *error) {
        
        NSLog(@"%@", response);
        
        NSDictionary *prevPhoto = response[@"prevphoto"];
        NSDictionary *nextPhoto = response[@"nextphoto"];
        
        NSDictionary *context = @{
            @"prevID": (!prevPhoto[@"id"] || [prevPhoto[@"id"] integerValue] == 0) ? @"" : prevPhoto[@"id"],
            @"nextID": (!nextPhoto[@"id"] || [nextPhoto[@"id"] integerValue] == 0) ? @"" : nextPhoto[@"id"]
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(context);
            }
        });
    }];
}

@end
