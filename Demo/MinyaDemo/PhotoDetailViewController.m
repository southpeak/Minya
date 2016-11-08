//
//  PhotoDetailViewController.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Minya.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo Detail";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.store fetchData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Test" object:nil userInfo:nil];
}

@end
