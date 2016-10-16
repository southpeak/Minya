//
//  PhotoDetailPipeline.h
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIPipeline.h"
#import "Photo.h"

@interface PhotoDetailPipeline : MIPipeline

// Normal data
@property (nonatomic, strong) Photo *photo;

// Flag data
@property (nonatomic, assign) BOOL flagRequestFinished;

// Input data
@property (nonatomic, assign) BOOL inputPrev;
@property (nonatomic, assign) BOOL inputNext;

@end
