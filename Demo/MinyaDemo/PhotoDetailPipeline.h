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

@property (nonatomic, strong) Photo *photo;

@property (nonatomic, assign) BOOL flagRequestFinished;

@property (nonatomic, assign) BOOL inputPrev;
@property (nonatomic, assign) BOOL inputNext;

@end
