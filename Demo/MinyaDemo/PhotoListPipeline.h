//
//  ResultListPipeline.h
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIPipeline.h"

@interface PhotoListPipeline : MIPipeline

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, assign) BOOL flagRequestFinished;

@property (nonatomic, assign) NSUInteger inputSelectedPhotoIndex;
@property (nonatomic, assign) BOOL inputFetchMoreData;

@property (nonatomic, strong, readonly) NSDictionary *contextForDetail;

@end
