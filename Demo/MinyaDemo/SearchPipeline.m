//
//  RootPipeline.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "SearchPipeline.h"

@implementation SearchPipeline

- (NSDictionary *)contextForSearch {
    return @{@"photo": self.inputSearchText ?: @""};
}

@end
