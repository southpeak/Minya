//
//  SearchPhotoDetailService.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "SearchPhotoDetailService.h"
#import "Photo.h"
#import <FlickrKit/FlickrKit.h>

@implementation SearchPhotoDetailService

- (void)requestWithParameters:(NSDictionary *)parameters success:(MIRequestSuccessBlock)success fail:(MIRequestFailBlock)fail {
    
    [[FlickrKit sharedFlickrKit] call:@"flickr.photos.getInfo" args:parameters completion:^(NSDictionary *response, NSError *error) {
        
        if (!error) {
            
            NSDictionary *photoDic = response[@"photo"];
            
            NSDictionary *dates = photoDic[@"dates"];
            NSDictionary *desc = photoDic[@"description"];
            NSDictionary *owner = photoDic[@"owner"];
            NSDictionary *title = photoDic[@"title"];
            NSArray *urls = photoDic[@"urls"][@"url"];
            
            NSDictionary *url = nil;
            if (urls.count > 0) {
                url = urls[0];
            }
            
            Photo *photo = [[Photo alloc] init];
            photo.taken = dates ? dates[@"taken"] : @"";
            photo.desc = desc ? desc[@"_content"] : @"";
            photo.owner = owner ? owner[@"realname"] : @"";
            photo.title = title ? title[@"_content"] : @"";
            photo.url = url ? url[@"_content"] : @"";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(photo);
                }
            });
        }
    }];
}

@end

// Example of the response data
//{
//    photo =     {
//        comments =         {
//            "_content" = 0;
//        };
//        dates =         {
//            lastupdate = 1476405997;
//            posted = 1476405996;
//            taken = "2016-10-01 21:31:46";
//            takengranularity = 0;
//            takenunknown = 0;
//        };
//        dateuploaded = 1476405996;
//        description =         {
//            "_content" = "";
//        };
//        editability =         {
//            canaddmeta = 0;
//            cancomment = 0;
//        };
//        farm = 6;
//        id = 30309964175;
//        isfavorite = 0;
//        license = 0;
//        media = photo;
//        notes =         {
//            note =             (
//            );
//        };
//        originalformat = jpg;
//        originalsecret = 8a96d1692c;
//        owner =         {
//            iconfarm = 1;
//            iconserver = 617;
//            location = "";
//            nsid = "117922183@N04";
//            "path_alias" = "<null>";
//            realname = "AJ Facundo";
//            username = "Wrestle MI Style \U2122 (2484630733)";
//        };
//        people =         {
//            haspeople = 0;
//        };
//        publiceditability =         {
//            canaddmeta = 0;
//            cancomment = 1;
//        };
//        rotation = 0;
//        "safety_level" = 0;
//        secret = b0611afcd0;
//        server = 5584;
//        tags =         {
//            tag =             (
//            );
//        };
//        title =         {
//            "_content" = "Who's going to super 32's! I'll be at 120, peep the shoes too \Ud83d\Ude09";
//        };
//        urls =         {
//            url =             (
//                               {
//                                   "_content" = "https://www.flickr.com/photos/117922183@N04/30309964175/";
//                                   type = photopage;
//                               }
//                               );
//        };
//        usage =         {
//            canblog = 0;
//            candownload = 1;
//            canprint = 0;
//            canshare = 1;
//        };
//        views = 0;
//        visibility =         {
//            isfamily = 0;
//            isfriend = 0;
//            ispublic = 1;
//        };
//    };
//    stat = ok;
//}
