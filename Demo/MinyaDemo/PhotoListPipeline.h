//
//  ResultListPipeline.h
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIPipeline.h"

@interface PhotoListPipeline : MIPipeline

// Normal data
@property (nonatomic, strong) NSMutableArray *photos;

// Flag data
@property (nonatomic, assign) BOOL flagRequestFinished;

// Input data
@property (nonatomic, assign) NSUInteger inputSelectedPhotoIndex;
@property (nonatomic, assign) BOOL inputFetchMoreData;

// Context data
// In general, context data is calculate property. They can be calculated
// from other property.
@property (nonatomic, strong, readonly) NSDictionary *contextForDetail;

@end
