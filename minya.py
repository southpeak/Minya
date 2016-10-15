#!/usr/bin/python

import string
import time
import sys

project_name = "MinyaDemo"
author_name = "author name"
company_name = "company name"
common_head_file = '#import "Minya.h"'		# If you don't want to import common file, just set it to ''

# Header File Header Comment
file_header = """//
// %s
// %s
//
// Created by %s on %s
// Copyright %s %s. All right reserved.
//
"""

# Create Pipeline Header file (.h)
pipeline_header = """
#import "MIPipeline.h"

@interface %s : MIPipeline

@end
"""

pipeline_implementation = """
#import "%s.h"

@implementation %s

@end
"""

store_header = """
#import "MIStore.h"

@interface %s : MIStore

@end
"""

store_implementation = """
#import "%s.h"
#import "%s.h"
%s

@interface %s ()

@property (nonatomic, strong) %s * %s;

@end

@implementation %s

- (instancetype)initWithContext:(NSDictionary<NSString *,id> *)context {
    
    self = [super initWithContext:context];
    
    if (self) {
        
    }
    
    return self;
}

- (void)fetchData {
    
}

- (__kindof MIPipeline *)pipeline {
    return self.%s;
}

- (void)addObservers {
    
}

+ (NSArray<NSString *> *)requiredParameters {
    return nil;
}

#pragma mark - Pipeline

- (%s *)%s {
    if (!_%s) {
        _%s = [[%s alloc] init];
    }
    return _%s;
}

@end
"""

view_header = """
#import <UIKit/UIKit.h>

@interface %s : UIView

@end
"""

view_implementation = """
#import "%s.h"
#import "UIView+MIPipeline.h"
#import "%s.h"

@interface %s ()

@property (nonatomic, strong) %s *pipeline;

@end

@implementation %s

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
}

@end
"""

view_controller_header = """
#import "MIViewController.h"

@interface %s : MIViewController

@end
"""

view_controller_implementation = """
#import "%s.h"
#import "%s.h"
%s

@interface %s ()

@property (nonatomic, strong) %s *pipeline;

@end

@implementation %s

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add you own code 
}

- (void)setupPipeline:(__kindof MIPipeline *)pipeline {
    self.pipeline = pipeline;
}

@end
"""

def create_mvcs(name):

	name = string.capitalize(name)

	pipeline_name = name + "Pipeline"
	store_name = name + "Store"
	view_name = name + "View"
	view_controller_name = name + "ViewController"
	lowwer_pipeline_name = lowwer_first_charector(pipeline_name)

	################## Pipeline #################

	fo = open(pipeline_name + '.h', "wb")
	writed_str = get_file_header(pipeline_name) + pipeline_header % (pipeline_name)
	fo.write(writed_str)
	fo.close()

	fo = open(pipeline_name + '.m', "wb")
	writed_str = get_file_header(pipeline_name, 'm') 
	writed_str = writed_str + pipeline_implementation % (pipeline_name, pipeline_name)
	fo.write(writed_str)
	fo.close()

	################## Store ##################

	fo = open(store_name + '.h', "wb")
	writed_str = get_file_header(store_name)
	writed_str = writed_str + store_header % (store_name)
	fo.write(writed_str)
	fo.close()

	fo = open(store_name + '.m', "wb")
	writed_str = get_file_header(store_name, 'm')
	writed_str = writed_str + store_implementation % (store_name, 
													  pipeline_name, 
													  common_head_file,
													  store_name, 
													  pipeline_name, 
													  lowwer_pipeline_name,
													  store_name,
													  lowwer_pipeline_name,
													  pipeline_name, 
													  lowwer_pipeline_name,
													  lowwer_pipeline_name,
													  lowwer_pipeline_name,
													  pipeline_name,
													  lowwer_pipeline_name)
	fo.write(writed_str)
	fo.close()

	################### View #######################

	fo = open(view_name + '.h', "wb")
	writed_str = get_file_header(view_name)
	writed_str = writed_str + view_header % (view_name)
	fo.write(writed_str)
	fo.close()

	fo = open(view_name + '.m', "wb")
	writed_str = get_file_header(view_name, 'm')
	writed_str = writed_str + view_implementation % (view_name,
													 pipeline_name,
													 view_name,
													 pipeline_name,
													 view_name)
	fo.write(writed_str)
	fo.close()

	################### ViewController ##############

	fo = open(view_controller_name + ".h", "wb")
	writed_str = get_file_header(view_controller_name)
	writed_str = writed_str + view_controller_header % (view_controller_name)
	fo.write(writed_str)
	fo.close()

	fo = open(view_controller_name + ".m", "wb")
	writed_str = get_file_header(view_controller_name, 'm')
	writed_str = writed_str + view_controller_implementation % (view_controller_name,
																pipeline_name,
																common_head_file,
																view_controller_name,
																pipeline_name,
																view_controller_name)
	fo.write(writed_str)
	fo.close()

def get_file_header(filename, type='h'):
	time_str = time.strftime("%Y/%m/%d", time.localtime())
	year_str = time.strftime("%Y", time.localtime())
	return file_header % (filename + "." + type, project_name, author_name, time_str, year_str, company_name)

def lowwer_first_charector(s):
	return string.lower(s[0]) + s[1:]

if __name__ == '__main__':
	argv = sys.argv
	if len(argv) > 1:
		create_mvcs(argv[1])

