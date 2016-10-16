//
//  RootPipeline.h
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "MIPipeline.h"

@interface SearchPipeline : MIPipeline

#pragma mark - input data
@property (nonatomic, copy) NSString *inputSearchText;
@property (nonatomic, assign) BOOL inputSearch;         // Just a flag that indicates the `GO` button clicked.
@property (nonatomic, assign) BOOL inputInterest;

#pragma mark - context data
@property (nonatomic, strong, readonly) NSDictionary *contextForSearch;

@end
