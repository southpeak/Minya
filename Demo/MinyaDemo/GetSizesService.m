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

// Example
//{
//    sizes =     {
//        canblog = 0;
//        candownload = 1;
//        canprint = 0;
//        size =         (
//                        {
//                            height = 75;
//                            label = Square;
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_86153b2612_s.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/sq/";
//                            width = 75;
//                        },
//                        {
//                            height = 150;
//                            label = "Large Square";
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_86153b2612_q.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/q/";
//                            width = 150;
//                        },
//                        {
//                            height = 56;
//                            label = Thumbnail;
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_86153b2612_t.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/t/";
//                            width = 100;
//                        },
//                        {
//                            height = 135;
//                            label = Small;
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_86153b2612_m.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/s/";
//                            width = 240;
//                        },
//                        {
//                            height = 180;
//                            label = "Small 320";
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_86153b2612_n.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/n/";
//                            width = 320;
//                        },
//                        {
//                            height = 281;
//                            label = Medium;
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_86153b2612.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/m/";
//                            width = 500;
//                        },
//                        {
//                            height = 360;
//                            label = "Medium 640";
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_86153b2612_z.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/z/";
//                            width = 640;
//                        },
//                        {
//                            height = 450;
//                            label = "Medium 800";
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_86153b2612_c.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/c/";
//                            width = 800;
//                        },
//                        {
//                            height = 576;
//                            label = Large;
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_86153b2612_b.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/l/";
//                            width = 1024;
//                        },
//                        {
//                            height = 900;
//                            label = "Large 1600";
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_a3ed09dd07_h.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/h/";
//                            width = 1600;
//                        },
//                        {
//                            height = 1152;
//                            label = "Large 2048";
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_16dfb27e65_k.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/k/";
//                            width = 2048;
//                        },
//                        {
//                            height = 2988;
//                            label = Original;
//                            media = photo;
//                            source = "https://farm6.staticflickr.com/5705/29793591633_050b76020a_o.jpg";
//                            url = "https://www.flickr.com/photos/68731317@N07/29793591633/sizes/o/";
//                            width = 5312;
//                        }
//                        );
//    };
//    stat = ok;
//}
