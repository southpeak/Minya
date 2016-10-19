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

// Example

//{
//    count =     {
//        "_content" = 7495;
//    };
//    nextphoto =     {
//        id = 0;
//    };
//    prevphoto =     {
//        farm = 6;
//        id = 30424951795;
//        license = 0;
//        media = photo;
//        owner = "8946624@N08";
//        secret = fedf4dcd4c;
//        server = 5750;
//        thumb = "https://farm6.staticflickr.com/5750/30424951795_fedf4dcd4c_s.jpg";
//        title = "20161017_170050";
//        url = "/photos/8946624@N08/30424951795/in/photostream/";
//    };
//    stat = ok;
//}
