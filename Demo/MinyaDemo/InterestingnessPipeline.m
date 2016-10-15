//
//  InterestingnessPipeline.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "InterestingnessPipeline.h"
#import "Minya.h"

@implementation InterestingnessPipeline

- (void)setShowImageAtIndex:(NSUInteger)index {
    
    NSDictionary *photo = self.photoListPipeline.photos[index];
    if (photo) {
        self.imagePipeline.photoID = photo[@"id"];
        self.imagePipeline.title = photo[@"title"];
    }
}

@end
