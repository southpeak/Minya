//
//  Photo.h
//  MinyaDemo
//
//  Created by Konka on 2016/10/14.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Photo class
 *
 *  If necessary, you can declare some model for MVCS.
 *  The model belongs to model layer, and in our example we have
 *  not too many model objects.
 */
@interface Photo : NSObject

@property (nonatomic, copy) NSString *taken;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

@end
